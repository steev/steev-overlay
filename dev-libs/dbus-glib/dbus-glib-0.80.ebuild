# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dbus-glib/dbus-glib-0.78.ebuild,v 1.4 2009/01/18 20:34:47 eva Exp $

inherit eutils multilib autotools bash-completion

DESCRIPTION="D-Bus bindings for glib"
HOMEPAGE="http://dbus.freedesktop.org/"
SRC_URI="http://dbus.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="|| ( GPL-2 AFL-2.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="bash-completion debug doc test"

RDEPEND=">=sys-apps/dbus-1.1.0
	>=dev-libs/glib-2.10
	>=dev-libs/expat-1.95.8"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext
	doc? (
		app-doc/doxygen
		app-text/xmlto
		>=dev-util/gtk-doc-1.4 )
	dev-util/gtk-doc-am"

BASH_COMPLETION_NAME="dbus"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-introspection.patch

	#epatch "${FILESDIR}"/${PN}-0.78-as-needed.patch

	# submitted upstream to bug #19325
	#epatch "${FILESDIR}"/${PN}-0.78-fix-building-tests.patch
	# Fix format-security warning (-Werror=format-security)
	epatch "${FILESDIR}"/${PN}-0.80-fix-format-security.patch
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable bash-completion) \
		$(use_enable debug verbose-mode) \
		$(use_enable debug checks) \
		$(use_enable debug asserts) \
		$(use_enable test tests) \
		$(use_with test test-socket-dir "${T}"/dbus-test-socket) \
		--localstatedir=/var \
		$(use_enable doc doxygen-docs) \
		$(use_enable doc gtk-doc)

	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog HACKING NEWS README

	#FIXME: We need --with-bash-completion-dir
	if use bash-completion ; then
		dobashcompletion "${D}"/etc/profile.d/dbus-bash-completion.sh
		rm -rf "${D}"/etc/profile.d
	fi
}

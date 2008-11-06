# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nmap/nmap-4.76.ebuild,v 1.6 2008/10/28 01:36:38 ranger Exp $

inherit eutils flag-o-matic

DESCRIPTION="A utility for network exploration or security auditing"
HOMEPAGE="http://nmap.org/"
SRC_URI="http://download.insecure.org/nmap/dist/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="gtk lua ssl"

DEPEND="dev-libs/libpcre
	net-libs/libpcap
	dev-libs/libdnet
	gtk? ( >=x11-libs/gtk+-2.6
		   >=dev-python/pygtk-2.6
		   || ( >=dev-lang/python-2.5
				>=dev-python/pysqlite-2 )
		 )
	ssl? ( dev-libs/openssl )"

pkg_setup() {
	if use gtk && has_version ">=dev-lang/python-2.5" &&
	   ! has_version ">=dev-python/pysqlite-2" &&
	   ! built_with_use dev-lang/python sqlite ; then
		eerror "In order to use the nmap GUI you have to either emerge dev-lang/python"
		eerror "with the 'sqlite' USE flag, or install dev-python/pysqlite-2*."
		die "sqlite support missing"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-4.75-include.patch"
	epatch "${FILESDIR}/${PN}-4.75-nolua.patch"
}

src_compile() {
	local myconf=""

	if use lua ; then
		if has_version ">=dev-lang/lua-5.1.3-r1" &&
		   built_with_use dev-lang/lua deprecated ; then
			myconf="--with-liblua"
		else
			myconf="--with-liblua=included"
		fi
	else
		myconf="--without-liblua"
	fi

	econf \
		'--with-libdnet=/usr' \
		"${myconf}" \
		$(use_with gtk zenmap) \
		$(use_with ssl openssl) || die
	emake || die
}

src_install() {
	LC_ALL=C emake DESTDIR="${D}" -j1 nmapdatadir=/usr/share/nmap install || die
	dodoc CHANGELOG HACKING docs/README docs/*.txt || die

	use gtk && doicon "${FILESDIR}/nmap-logo-64.png"
}

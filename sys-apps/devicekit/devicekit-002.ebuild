# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="DeviceKit"

DESCRIPTION="Eventual replacement of HAL"
HOMEPAGE="http://i.dun.no"
SRC_URI="http://hal.freedesktop.org/releases/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.12
	>=dev-libs/dbus-glib-0.76
	>=sys-fs/udev-130"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.59"

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() {
	econf --enable-man-pages \
	--localstatedir=/var
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc NEWS README AUTHORS ChangeLog

	keepdir /var/run/devkit
}

# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="A library that provides automatic proxy configuration management"
HOMEPAGE="http://code.google.com/p/libproxy/"
SRC_URI="http://libproxy.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gnome kde mozilla networkmanager python webkit"

RDEPEND="gnome? ( >=gnome-base/gconf-2
		x11-libs/libXmu
		x11-libs/libX11 )
	kde? ( x11-libs/libXmu
		x11-libs/libX11 )
	mozilla? ( net-libs/xulrunner )
	networkmanager? ( sys-apps/dbus )
	python? ( >=dev-lang/python-2.5 )
	webkit? ( net-libs/webkit-gtk )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	networkmanager? ( net-misc/networkmanager )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-fix-dbus-include.patch"

	eautoreconf
}

src_compile() {
	econf \
		$(use_with gnome) \
		$(use_with kde) \
		$(use_with mozilla mozjs) \
		$(use_with networkmanager) \
		$(use_with python) \
		$(use_with webkit) || die "configure failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	dodoc AUTHORS ChangeLog README
}

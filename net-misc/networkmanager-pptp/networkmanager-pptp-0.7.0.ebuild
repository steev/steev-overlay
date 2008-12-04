# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

# NetworkManager likes itself with capital letters
MY_P=${P/networkmanager/NetworkManager}

DESCRIPTION="NetworkManager PPTP plugin."
HOMEPAGE="http://www.gnome.org/projects/NetworkManager/"
SRC_URI="ftp://ftp.gnome.org/pub/gnome/sources/NetworkManager-pptp/0.7/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~ppc ~x86"
IUSE="gnome"

RDEPEND="
	>=net-misc/networkmanager-0.7.0
	gnome? ( >=x11-libs/gtk+-2.10
		>=gnome-base/libglade-2
		>=gnome-base/libgnomeui-2.20
		>=gnome-base/gconf-2.20
		>=gnome-base/gnome-keyring-2.20
		)"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

S=${WORKDIR}/${MY_P}

src_compile() {
	ECONF="--disable-more-warnings \
		$(use_with gnome)"

	econf ${ECONF} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README
}

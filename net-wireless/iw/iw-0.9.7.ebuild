# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $HEADER: $

inherit eutils versionator

DESCRIPTION="Tool for setting monitor mode interfaces with mac80211 drivers"
#HOMEPAGE="http://www.aircrack-ng.org"
HOMEPAGE="http://wireless.kernel.org/en/users/Documentation/iw"
#SRC_URI="http://dl.aircrack-ng.org/${PN}.tar.bz2"
SRC_URI="http://wireless.kernel.org/download/iw/${P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="=dev-libs/libnl-1*"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.22"

src_unpack() {
	unpack ${A}
	sed -i -e '/^CFLAGS/s/-O2 -g//' "${S}"/Makefile || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

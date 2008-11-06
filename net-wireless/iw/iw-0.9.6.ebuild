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

DEPEND=">=dev-libs/libnl-1.1"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/iw-0.9.6-remove_useless_code.patch
}

src_compile() {
	emake  || die "emake failed"
}

src_install() {
	mkdir -p ${D}usr/bin
	cp iw ${D}usr/bin || die "Could not copy iw"
}

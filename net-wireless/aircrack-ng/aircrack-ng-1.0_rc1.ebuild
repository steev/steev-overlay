# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_PV=$(replace_version_separator 2 '-')

DESCRIPTION="WLAN tools for breaking 802.11 WEP/WPA keys"
HOMEPAGE="http://www.aircrack-ng.org"
SRC_URI="http://download.aircrack-ng.org/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="+sqlite"

DEPEND="dev-libs/openssl
        sqlite? ( >=dev-db/sqlite-3.4 )"
RDEPEND="${DEPEND}
	net-wireless/iw"

S="${WORKDIR}/${PN}-${MY_PV}"

have_sqlite() {
	use sqlite && echo "true" || echo "false"
}

src_compile() {
	emake sqlite=$(have_sqlite) || die "emake failed"
}

src_install() {
	emake prefix="${ROOT}/usr" DESTDIR="${D}" sqlite=$(have_sqlite) install || die "emake install failed"
}

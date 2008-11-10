# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="LOss Of Radio CONnectivity"
HOMEPAGE="http://802.11ninja.net/svn/lorcon/"
SRC_URI="http://steev.net/files/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e 's:-o root ::' Makefile.in
}

src_compile() {
	econf || die "Configure failed."
}

src_install() {
	emake DESTDIR=${D} install || die "Install failed."
}

# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="a dynamic, any to any, pixel format conversion library"
HOMEPAGE="http://www.gegl.org/babl/"
SRC_URI="ftp://ftp.gtk.org/pub/${PN}/0.0/${P}.tar.bz2"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="inkscape w3m"

RDEPEND=""
DEPEND="${RDEPEND}
	inkscape? ( media-gfx/inkscape )
	w3m? ( www-client/w3m )"

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc ChangeLog INSTALL README NEWS
}

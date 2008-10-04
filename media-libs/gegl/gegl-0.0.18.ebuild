# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="a graph based image processing framework."
HOMEPAGE="http://www.gegl.org/"
SRC_URI="ftp://ftp.gimp.org/pub/${PN}/0.0/${P}.tar.bz2"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="jpeg graphviz openexr ruby sdl svg debug doc threads gtk cairo pango \
	enscript asciidoc ffmpeg workshop mmx sse"
#
# gegl may now (since 0.0.22) use sse or mmx for accelerated calculations
#

# The workshop directory (and thus the `workshop' use flag) is where
# experimental stuff is built into.  You shouldn't need it unless you're
# developing on gegl yourself.  Maybe therefore it should only exist in
# the svn ebuild?

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-libs/glib-2.12.0
	>=media-libs/babl-0.0.22
	media-libs/libpng
	gtk? ( >=x11-libs/gtk+-2.8.6 )
	cairo? ( x11-libs/cairo )
	pango? ( x11-libs/pango )
	jpeg? ( media-libs/jpeg )
	sdl? ( media-libs/libsdl )
	openexr? ( media-libs/openexr )
	svg? ( >=gnome-base/librsvg-2.14.0 )
	ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20080326 )
        workshop? ( >=dev-lang/lua-5.1.0 ) 
	graphviz? ( media-gfx/graphviz )
	enscript? ( app-text/enscript )
	asciidoc? ( app-text/asciidoc )
        "

#
# Meaning of the optional dependencies (from http://www.gegl.org): 
#       SDL (display op)
#       libjpeg (jpg loader op)
#       libopenexr (exr loader op)
#       cairo, pango (text source op)
#       avcodec, avformat (ff-load and experimental ff-save)
#       librsvg (svg loader)
#       asciidoc, enscript (documentation)
#       graphviz (graphviz graph description from command line)
#       
#
# Unnecessary dependencies:
#	ruby? ( dev-lang/ruby ) ## -> only if building from svn
#	

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/gegl-libavformat.patch
	cd ${S}
}

src_compile() {
	local MYCONF="$(use_enable debug) $(use_enable doc docs) \
		$(use_enable threads mp) $(use_with jpeg libjpeg) \
		$(use_enable workshop) \
                $(use_enable mmx) \
                $(use_enable sse) \
                "

	econf ${MYCONF} || die "econf failed" 
	env GEGL_SWAP=${WORKDIR} emake || die "emake failed"
}

src_install() {
	# emake install doesn't install anything
	einstall || die "einstall failed"
	dodoc ChangeLog INSTALL README NEWS

	# don't know why einstall omits this?!
	insinto /usr/include/${PN}-0.0/${PN}/buffer/
	doins ${WORKDIR}/${P}/${PN}/buffer/*.h || die "doins buffer failed"
	insinto /usr/include/${PN}-0.0/${PN}/module/
	doins ${WORKDIR}/${P}/${PN}/module/*.h || die "doins module failed"
}

# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/sqsh/sqsh-2.1.4.ebuild,v 1.2 2007/07/22 10:01:39 graaff Exp $

inherit eutils autotools

DESCRIPTION="Replacement for the venerable 'isql' program supplied by Sybase."
HOMEPAGE="http://sourceforge.net/projects/sqsh/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
#	mirror://gentoo/${PN}-2.1.3-autotools.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE="readline X motif"
KEYWORDS="~x86 ~amd64 ~x86-fbsd"

DEPEND="dev-db/freetds
	readline? ( sys-libs/readline )
	X? (
		x11-libs/libXaw
		x11-libs/libXt
		x11-libs/libXext
		x11-libs/libXmu
		x11-libs/libX11 )
	motif? ( x11-libs/openmotif )
	virtual/libc"

src_unpack() {
	unpack ${A}; cd ${S}
	epatch "${FILESDIR}"/${PN}.diff
	epatch "${FILESDIR}"/${PN}-2.1.3-configure.in-motif.patch
	epatch "${FILESDIR}"/${PN}-2.1.4-configure.in-x.patch
	# Patch knicked from ports so that we don't pass -ldb when in a BSD
	epatch ${FILESDIR}/${PN}-2.1.3-fbsd-configure.patch
	eautoconf
}

src_compile() {
	export SYBASE=/usr

	local myconf

	econf \
		$(use_with readline) \
		$(use_with X x) \
		$(use_with motif) \
		${myconf} || die

	emake || die
}

src_install () {
	einstall install.man || die
	#emake DESTDIR="${D}" install
	#einstall DESTDIR="${D}" install.man || die
	dodoc INSTALL README doc/*
}

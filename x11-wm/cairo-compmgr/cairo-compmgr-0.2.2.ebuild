# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="Cairo Composite Manager is a versatile and extensible composite
manager which use cairo for rendering."
HOMEPAGE="http://cairo-compmgr.tuxfamily.org/"
SRC_URI="http://download.tuxfamily.org/ccm/cairo-compmgr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="gnome-base/gconf
	>=x11-libs/gtk+-2.10
	>=media-libs/glitz-0.5.6
	>=x11-libs/pixman-0.9.6
	>=x11-proto/glproto-1.4.9
	gnome-base/libgnomeui"
DEPEND="${RDEPEND}"


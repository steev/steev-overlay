# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION=""
HOMEPAGE="http://www.getdropbox.com/"
SRC_URI="http://linux.getdropbox.com/packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.16.0
	>=gnome-base/nautilus-2.20.0
	dev-python/docutils
	>=x11-libs/libnotify-0.4.4"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.20"

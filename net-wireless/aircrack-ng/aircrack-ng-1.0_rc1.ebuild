# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

MY_PV=${PV/_/-}

DESCRIPTION="WLAN tools for breaking 802.11 WEP/WPA keys"
HOMEPAGE="http://www.aircrack-ng.org"
SRC_URI="http://download.aircrack-ng.org/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~x86-fbsd"
IUSE="wifi"

DEPEND="wifi? ( net-libs/libpcap )"

S="${WORKDIR}/${PN}-${MY_PV}"

src_compile() {
	local target
	use wifi || target="userland"
	emake -e CC="$(tc-getCC)" ${target} || die "emake failed"
}

src_install() {
	local target
	use wifi && target="install" || target="install_userland"
	emake \
		prefix=/usr \
		docdir="/usr/share/doc/${PF}" \
		mandir="/usr/share/man/man1" \
		destdir="${D}" \
		${target} \
		doc \
		|| die "emake install failed"
}

src_test() {
	#./makeivs wep.ivs 11111111111111111111111111 || die 'generating ivs file failed'
	#./aircrack-ng wep.ivs || die 'cracking WEP key failed'

	# Upstream uses signal in order to quit,
	# So protect busybox with process group leader.
	"$(tc-getCC)" -o process-group-leader "${FILESDIR}/process-group-leader.c"
	./process-group-leader ./aircrack-ng -w test/password.lst test/wpa.cap || die 'cracking WPA key failed'
}

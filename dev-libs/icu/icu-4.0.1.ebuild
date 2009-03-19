# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

DESCRIPTION="International Components for Unicode"
HOMEPAGE="http://www.icu-project.org/ http://ibm.com/software/globalization/icu/"

BASEURI="http://download.icu-project.org/files/${PN}4c/${PV}"
DOCS_PV="$(get_version_component_range 1-2)"
DOCS_BASEURI="http://download.icu-project.org/files/${PN}4c/${DOCS_PV}"
DOCS_PV="${DOCS_PV/./_}"
SRCPKG="${PN}4c-${PV//./_}-src.tgz"
USERGUIDE="${PN}-${DOCS_PV}-userguide.zip"
APIDOCS="${PN}4c-${DOCS_PV}-docs.zip"

SRC_URI="${BASEURI}/${SRCPKG}
	doc? ( ${DOCS_BASEURI}/${USERGUIDE}
		${DOCS_BASEURI}/${APIDOCS} )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE="debug doc examples"

DEPEND="doc? ( app-arch/unzip )"
RDEPEND=""

S=${WORKDIR}/${PN}/source

src_unpack() {
	unpack ${SRCPKG}
	if use doc ; then
		mkdir userguide
		pushd ./userguide > /dev/null
		unpack ${USERGUIDE}
		popd

		mkdir apidocs
		pushd ./apidocs > /dev/null
		unpack ${APIDOCS}
		popd
	fi

	# See http://qa.openoffice.org/issues/show_bug.cgi?id=83146
	# and http://bugs.icu-project.org/trac/ticket/5498 for details
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-3.8-setBreakType-public.diff

	# Bug 208001
	#epatch "${FILESDIR}"/${PN}-3.8-regexp-CVE-2007-4770+4771.diff

	# do not hardcode used CFLAGS, LDFLAGS etc. into icu-config
	# Bug 202059
	# http://bugs.icu-project.org/trac/ticket/6102
	for x in CFLAGS CXXFLAGS CPPFLAGS LDFLAGS ; do
		sed -i -e "/^${x} =.*/s:@${x}@::" config/Makefile.inc.in || die "sed failed"
	done
}

src_compile() {
	econf \
		--enable-static \
		$(use_enable debug) \
		$(use_enable examples samples)

	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dohtml ../readme.html
	dodoc ../unicode-license.txt
	if use doc ; then
		insinto /usr/share/doc/${PF}/html/userguide
		doins -r "${WORKDIR}"/userguide/*

		insinto /usr/share/doc/${PF}/html/apidocs
		doins -r "${WORKDIR}"/apidocs/*
	fi
}

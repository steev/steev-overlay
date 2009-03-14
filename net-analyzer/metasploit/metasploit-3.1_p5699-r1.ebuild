# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/metasploit/metasploit-3.1_p5699-r1.ebuild,v 1.3 2008/11/09 14:52:13 nixnut Exp $

MY_P=${PN/metasploit/framework}-${PV}

# Metasploit uses subversion as a *normal* update mechanism for stable branches
# of the package. This ebuild uses _p<number> inside $PV to install updated up
# to revision <number> version of framework. For more information, take a look
# at bug #195924.
if [[ "${PV}" =~ (_p)([0-9]+) ]] ; then
	inherit subversion
	SRC_URI=""
	MTSLPT_REV=${BASH_REMATCH[2]}
	ESVN_REPO_URI="https://metasploit.com/svn/framework3/branches/framework-${PV%_p*}/@${MTSLPT_REV}"
else
	SRC_URI="http://sugar.metasploit.com/releases/${MY_P}.tar.gz"
fi

DESCRIPTION="Advanced open-source framework for developing, testing, and using vulnerability exploit code"
HOMEPAGE="http://www.metasploit.org/"

LICENSE="MSF-1.2"
SLOT="3"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="gtk sqlite sqlite3 postgres httpd"

# blocker on ruby-1.8.7:
# http://spool.metasploit.com/pipermail/framework/2008-September/003671.html
RDEPEND="dev-lang/ruby
	!<=dev-lang/ruby-1.8.7_p72-r2
	gtk? ( dev-ruby/ruby-libglade2 )
	httpd? ( =dev-ruby/rails-1.2* )
	sqlite? ( dev-ruby/sqlite-ruby
		dev-ruby/activerecord )
	sqlite3? ( dev-ruby/sqlite3-ruby
		 dev-ruby/activerecord )
	postgres? ( dev-ruby/ruby-postgres
		dev-ruby/activerecord )"
DEPEND=""

S=${WORKDIR}/${MY_P}

src_compile() {
	sed -i -e "s/RAILS_GEM_VERSION = '1.2.2'/RAILS_GEM_VERSION = '1.2'/" \
		data/msfweb/config/environment.rb || die "sed failed"
	sed -i \
		's#http://metasploit3.com/msf/support#http://metasploit.com/framework/support#' \
				lib/msf/ui/gtk2/app.rb
}

src_install() {
	if [[ "${SRC_URI}" != "" ]] ; then
		find "${S}" -type d -name ".svn" -print0 | xargs -0 -n1 rm -R
	fi

	# should be as simple as copying everything into the target...
	dodir /usr/lib/${PN}${SLOT}
	cp -R "${S}"/* "${D}"/usr/lib/${PN}${SLOT} || die "Copy files failed"
	rm -Rf "${D}"/usr/lib/${PN}${SLOT}/documentation "${D}"/usr/lib/${PN}${SLOT}/README

	# do not remove LICENSE, bug #238137
	dodir /usr/share/doc/${PF}
	cp -R "${S}"/{documentation,README} "${D}"/usr/share/doc/${PF}
	dosym /usr/share/doc/${PF}/documentation /usr/lib/${PN}${SLOT}/documentation

	dodir /usr/bin/
	for file in `ls msf*`; do
		dosym /usr/lib/${PN}${SLOT}/${file} /usr/bin/${file}${SLOT}
	done

	chown -R root:0 "${D}"

	if use httpd; then
		newinitd "${FILESDIR}"/msfweb${SLOT}.initd msfweb${SLOT} \
			|| die "newinitd failed"
		newconfd "${FILESDIR}"/msfweb${SLOT}.confd msfweb${SLOT} \
			|| die "newconfd failed"
	fi
}

pkg_postinst() {
	if [[ "${SRC_URI}" == "" ]] ; then
		elog "If you wish to update ${PN} manually simply run:"
		elog
		elog "ESVN_REVISION=<rev> emerge =${PF}"
		elog
		elog "where <rev> is either HEAD (in case you wish to get all updates)"
		elog "or specific revision number. But NOTE, this update will vanish"
		elog "next time you reemerge ${PN}. To make update permanent either"
		elog "create ebuild with specific revision number inside your overlay"
		elog "or report revision bump bug at http://bugs.gentoo.org ."
		elog
		elog "In case you use portage it's also possible to create"
		elog "/etc/portage/env/${CATEGORY}/${PN} file with ESVN_REVISION=<rev>"
		elog "content. Then each time you run emerge ${PN} you'll have said"
		elog "<rev> installed. For example, if you run"
		elog " # mkdir -p /etc/portage/env/${CATEGORY}"
		elog " # echo ESVN_REVISION=HEAD >> /etc/portage/env/${CATEGORY}/${PN}"
		elog "each time you reemerge ${PN} it'll be updated to get all possible"
		elog "updates for framework-${PV%_p*} branch."
		elog "You can do similar things in paludis using /etc/paludis/bashrc."
	else
		ewarn "${PN} version you installed is for testing purposes only"
		ewarn "as it's impossible to update it. For day by day work use"
		ewarn "different version."
	fi
}

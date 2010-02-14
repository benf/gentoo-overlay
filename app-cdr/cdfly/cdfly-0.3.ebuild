# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils qt4

DESCRIPTION="The Cross-Platform CD Collection Manager"
HOMEPAGE="http://cdfly.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( x11-libs/qt-gui:4 <x11-libs/qt-4.4.0:4 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

pkg_setup()
{
	qt4_pkg_setup
	if has_version qt-sql ; then
		if  ! built_with_use x11-libs/qt-sql sqlite ; then
			echo
			eerror "Please enable 'sqlite' in USE flags for qt-sql."
			die "x11-libs/qt-sql is missing the sqlite flag."
		fi
	elif ! built_with_use x11-libs/qt sqlite ; then
		echo
		eerror  "Please enable 'sqlite' in USE flags for qt-sql."
		die "x11-libs/qt-sql is missing the sqlite flag."
	fi
}

src_compile()
{
	eqmake4 || die "qmake failed"
	emake || die "make failed"
}

src_install()
{
	dobin ${PN}
	doicon ${PN}.png

	insinto /usr/share/${PN}
	doins *.qm

	make_desktop_entry ${PN} "CdFly" ${PN}.png "Utility;"
}


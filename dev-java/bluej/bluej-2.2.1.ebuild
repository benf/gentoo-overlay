# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

####inherit eutils java-pkg
inherit eutils java-pkg-2

IUSE="doc"

MY_P=${P//.}
#MY_P=${MY_P/-bin}
DESCRIPTION="BlueJ is an integrated Java environment specifically designed for introductory teaching."
SRC_URI="http://www.bluej.org/download/files/${MY_P}.jar
	doc? ( http://www.bluej.org/tutorial/tutorial.pdf
	http://bluej.org/tutorial/tutorial-201.pdf
	http://bluej.org/download/files/bluej-ref-manual.pdf
	http://www.bluej.org/tutorial/testing-tutorial.pdf )"
HOMEPAGE="http://www.bluej.org"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RESTRICT="strip"

RDEPEND=""
DEPEND=""

src_unpack()
{
	unpack ${MY_P}.jar
	unpack ./bluej-dist.jar

	if use doc; then
		cp "${DISTDIR}/bluej-ref-manual.pdf" "${S}"
		cp "${DISTDIR}/tutorial-201.pdf" "${S}"
		cp "${DISTDIR}/tutorial.pdf" "${S}"
		cp "${DISTDIR}/testing-tutorial.pdf" "${S}"
	fi
}

src_compile() { :; }

src_install()
{
	insinto "/usr/share/${PN}/"
	doins -r lib/ examples/

	newbin "${FILESDIR}/${PN}.sh" bluej

	insinto /etc
	doins lib/bluej.defs
	dosym /etc/bluej.defs "/usr/share/${PN}/lib/bluej.defs"

	use doc && dodoc *.pdf

	insinto /usr/share/pixmaps
	newins "${FILESDIR}/bluej-icon2.xpm" bluej.xpm

	make_desktop_entry "${PN}" BlueJ "${PN}" "Application;Development"
}


# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"
# Not tested with Python 3.
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_MODNAME="dbtexmf"

inherit distutils eutils

DESCRIPTION="Transform DocBook using TeX macros"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://dblatex.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="app-text/texlive
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-latexrecommended
	dev-texlive/texlive-mathextra
	dev-texlive/texlive-pictures
	dev-texlive/texlive-xetex
	dev-libs/libxslt
	app-text/docbook-xml-dtd
	gnome-base/librsvg"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s:base=package_base:base='/usr/share/dblatex/':" scripts/dblatex
	sed -i -e 's/"inkscape.*" % /"rsvg-convert -f %s -o %s %s" % /' \
		lib/dbtexmf/core/imagedata.py

	epatch "${FILESDIR}/dblatex-0.3.4-install_layout.patch"

	distutils_src_prepare
}

src_install() {
	distutils_src_install
	dobin "${S}"/scripts/dblatex || die "dobin failed"

	mv "${D}"/usr/share/doc/${PN} "${D}"/usr/share/doc/${PF} || die "mv doc"
}


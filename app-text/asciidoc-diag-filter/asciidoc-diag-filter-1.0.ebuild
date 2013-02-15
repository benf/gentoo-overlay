# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Embed blockdiag diagrams in asciidoc with a filter"
HOMEPAGE="https://code.google.com/p/asciidoc-diag-filter/"
SRC_URI="https://asciidoc-diag-filter.googlecode.com/files/diag_filter.zip"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-office/blockdiag
	app-office/seqdiag
	app-office/nwdiag
	app-office/actdiag"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/asciidoc/filters/diag
	doins diag-filter.conf
}

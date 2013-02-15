# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit python distutils

DESCRIPTION="Generate sequence-diagram image file from spec-text file"
HOMEPAGE="http://blockdiag.com/"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/imaging-1.1.5
	app-office/blockdiag
	dev-python/webcolors
	dev-python/funcparserlib"
RDEPEND="${DEPEND}"

# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="QPDF is a C++ library and set of programs that inspect and manipulate the structure of PDF files."
HOMEPAGE="http://qpdf.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"


src_configure() {
	econf --disable-stripping || die "configure failed!"
}
src_install() {
	emake DESTDIR="${D}" install || die "make install failed!"
}

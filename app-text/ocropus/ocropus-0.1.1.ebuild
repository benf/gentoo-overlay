# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="OCRopus is a state-of-the-art document analysis and OCR system."
HOMEPAGE="http://code.google.com/p/ocropus/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=">=app-text/tesseract-1.04b
	app-text/aspell
	media-libs/tiff
	media-libs/libpng
	media-libs/jpeg"
DEPEND="${RDEPEND}
	dev-util/jam"

src_compile() {
	econf --with-tesseract=/usr || die "econf failed"
	emake || die "emake failed"
}

src_test() {
	cd "${S}/testing"
	./test-compile || die "Tests failed to compile"
	./test-run || die "At least one test failed"
}

src_install() {
	dobin ocropus-cmd/ocropus
	dodoc README DIRS
}

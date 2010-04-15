# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="The Portage C Compiler"
HOMEPAGE="http://pcc.ludd.ltu.se/"
SRC_URI="ftp://pcc.ludd.ltu.se/pub/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	econf "strip=no" || die "configure failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed."
}

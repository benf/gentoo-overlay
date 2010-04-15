# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

ECVS_SERVER="pcc.ludd.ltu.se:/cvsroot"
ECVS_USER="anonymous"
ECVS_AUTH="pserver"

ECVS_MODULE="${PN}"

inherit cvs toolchain-funcs

DESCRIPTION="Portable C Compiler libs"
HOMEPAGE="http://pcc.ludd.ltu.se/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_configure() {
	CC=$(tc-getCC) econf || die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed."
}

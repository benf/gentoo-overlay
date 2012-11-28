# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="SNMP Text Traffic Grapher"
HOMEPAGE="http://www.tenox.tc/out#ttg"
SRC_URI="http://www.tenox.tc/out/ttg.c"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="net-analyzer/net-snmp"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_unpack()
{
	cp ${DISTDIR}/${A} ${WORKDIR}
}

src_compile()
{
	eval `tc-getCC` -o ttg ttg.c -lnetsnmp
}

src_install()
{
	doexe ttg
}

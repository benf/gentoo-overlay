# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EHG_REPO_URI="http://mercurial.intuxication.org/hg/scan-s2/"

inherit mercurial toolchain-funcs

DESCRIPTION="DVB scan utility using S2API"
HOMEPAGE="http://mercurial.intuxication.org/hg/scan-s2"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i  -e 's:^BIND.*$:BIND=$(DESTDIR)/usr/bin/:' \
		-e 's:^install.*$:\0\n\tmkdir -p $(BIND):' \
		-e 's:$(INCLUDE):\0 $(CFLAGS):' \
		-e 's:$(CFLG):$(LDFLAGS):' \
		Makefile
}

src_compile()
{
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" CFLAGS="${CFLAGS}" \
		|| die "make failed."
}
src_install()
{
	emake DESTDIR="${D}" install || die "make install failed."
	dodir /usr/share/${PN}/
	cp -r ${S}/{atsc,dvb-{c,s}} "${D}"/usr/share/"${PN}"/
}

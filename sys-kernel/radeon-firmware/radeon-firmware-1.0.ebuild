# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


DESCRIPTION="radeon KMS firmware"
HOMEPAGE="http://people.freedesktop.org/~agd5f/radeon_ucode/"
SRC_URI="http://people.freedesktop.org/~agd5f/radeon_ucode/R600_rlc.bin 
		http://people.freedesktop.org/~agd5f/radeon_ucode/R700_rlc.bin"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""
S=${WORKDIR}

src_unpack() {
	cp ${DISTDIR}"/R600_rlc.bin" ${DISTDIR}"/R700_rlc.bin" ${S}
}

src_install() {
	insinto /lib/firmware/radeon
	doins R600_rlc.bin
	doins R700_rlc.bin
}

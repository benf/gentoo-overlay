# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit toolchain-funcs autotools-utils

DESCRIPTION="C bindings for Google's Protocol Buffers"
HOMEPAGE="http://protobuf-c.googlecode.com/"
SRC_URI="${HOMEPAGE}/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="protoc static-libs"

DEPEND="protoc? ( dev-libs/protobuf )"

RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=(
		$(use_enable protoc)
		"--with-endianness=$(tc-endian)"
	)
	autotools-utils_src_configure
}

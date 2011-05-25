# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools autotools-utils

DESCRIPTION="C bindings for Google's Protocol Buffers"
HOMEPAGE="http://protobuf-c.googlecode.com/"
SRC_URI="${HOMEPAGE}/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="static-libs"

DEPEND=""

RDEPEND="${DEPEND}"

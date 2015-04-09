# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools autotools-utils

DESCRIPTION="network projector control utility based on pjlink protocol"
HOMEPAGE="https://gitorious.org/pjctl/pjctl"
SRC_URI="https://bnfr.net/downloads/pjctl/pjctl-1.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/openssl"

RDEPEND="${DEPEND}"

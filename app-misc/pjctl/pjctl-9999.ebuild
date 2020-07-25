# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://git.bnfr.net/pjctl"
AUTOTOOLS_AUTORECONF=1

inherit autotools autotools-utils git-r3

DESCRIPTION="network projector control utility based on pjlink protocol"
HOMEPAGE="https://git.bnfr.net/pjctl"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl"

RDEPEND="${DEPEND}"

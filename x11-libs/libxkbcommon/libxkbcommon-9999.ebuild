# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://anongit.freedesktop.org/~krh/libxkbcommon"
EGIT_BOOTSTRAP="eautoreconf"

inherit autotools autotools-utils git

DESCRIPTION="common xkb library"
HOMEPAGE="http://cgit.freedesktop.org/~krh/libxkbcommon/"
SRC_URI=""

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-proto/kbproto-1.0.5"
RDEPEND="${DEPEND}"

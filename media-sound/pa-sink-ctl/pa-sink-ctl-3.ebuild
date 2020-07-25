# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils

DESCRIPTION="NCurses based Pulseaudio control client"
HOMEPAGE="https://git.bnfr.net/pa-sink-ctl"
SRC_URI="https://bnfr.net/downloads/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-sound/pulseaudio
	sys-libs/ncurses
	app-arch/xz-utils"
RDEPEND="${DEPEND}"

DOCS=( "README" "AUTHORS" )

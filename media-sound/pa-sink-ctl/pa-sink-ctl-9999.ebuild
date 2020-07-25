# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://git.bnfr.net/pa-sink-ctl"
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils git-r3

DESCRIPTION="NCurses based Pulseaudio control client"
HOMEPAGE="https://git.bnfr.net/pa-sink-ctl"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-sound/pulseaudio
	sys-libs/ncurses"
RDEPEND="${DEPEND}"

DOCS=( "README" "AUTHORS" )

# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://gitorious.org/pa-sink-ctl/pa-sink-ctl.git"
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils git

DESCRIPTION="NCurses based Pulseaudio control client"
HOMEPAGE="https://gitorious.org/pa-sink-ctl/pages/Home"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-sound/pulseaudio
	sys-libs/ncurses"
RDEPEND="${DEPEND}"

DOCS=( "README" "AUTHORS" )

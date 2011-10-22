# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools-utils

DESCRIPTION="NCurses based Pulseaudio control client"
HOMEPAGE="http://gitorious.org/pa-sink-ctl"
SRC_URI="http://gitorious.org/${PN}/${PN}-gitorious-wiki/blobs/raw/master/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-sound/pulseaudio
	sys-libs/ncurses"
RDEPEND="${DEPEND}"

DOCS=( "README" "AUTHORS" )

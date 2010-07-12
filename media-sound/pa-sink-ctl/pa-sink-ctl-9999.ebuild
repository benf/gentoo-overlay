# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://gitorious.org/pa-sink-ctl/pa-sink-ctl.git"
inherit git autotools

DESCRIPTION="NCurses based Pulseaudio control client"
HOMEPAGE="http://gitorious.org/pa-sink-ctl"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-sound/pulseaudio
	sys-libs/ncurses"
RDEPEND="${DEPEND}"

DOCS="README AUTHORS ChangeLog"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed!"
	dodoc ${DOCS}
}

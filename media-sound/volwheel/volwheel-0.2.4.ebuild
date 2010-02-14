# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Tray icon to change volume with the mouse"
HOMEPAGE="http://oliwer.net/b/volwheel.html"
SRC_URI="http://olwtools.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl
	>=dev-perl/gtk2-perl-1.182
	dev-perl/gtk2-trayicon
	media-sound/alsa-utils"
RDEPEND="${DEPEND}"

src_install()
{
	dobin ${PN}
	dodoc ChangeLog README
	insinto /usr/share/pixmaps
	doins ${PN}.png
}


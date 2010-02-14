# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-mod

DESCRIPTION="Legacy driver for the RaLink RT73 wireless chipsets"
#HOMEPAGE: mirror: "http://aspj.aircrack-ng.org/"
HOMEPAGE="http://homepages.tu-darmstadt.de/~p_larbig/wlan"
SRC_URI="${HOMEPAGE}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="net-wireless/wireless-tools
		net-wireless/rt73-firmware"

MODULE_NAMES="rt73(net:${S}/Module)"
MODULESD_RT73_ALIASES=('rausb? rt73')

src_install()
{
	linux-mod_src_install

	dodoc README TESTING IWPRIV_USAGE FAQ CHANGELOG
}

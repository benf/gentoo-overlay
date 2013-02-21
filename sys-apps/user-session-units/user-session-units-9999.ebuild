# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="https://github.com/sofar/user-session-units.git"
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils linux-info systemd git-2

DESCRIPTION="A collection of units for the systemd user session"
HOMEPAGE="https://github.com/sofar/user-session-units"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/systemd
	sys-apps/xorg-launch-helper"
RDEPEND="${DEPEND}"

src_configure() {
	# FIXME: configure script doesnt handle systemd{system,user}unitdir..
	#local myeconfargs=(
	#	--with-systemdsystemunitdir="$(systemd_get_unitdir)"
	#	--with-systemduserunitdir="$(systemd_get_userunitdir)"
	#)
	# FIXME: example services installation is completely automagic..
	autotools-utils_src_configure
}

pkg_pretend() {
	local CONFIG_CHECK="~MEMCG"
	check_extra_config
}

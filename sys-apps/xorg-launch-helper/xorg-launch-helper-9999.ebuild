# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="https://github.com/sofar/xorg-launch-helper.git"
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils systemd git-2

DESCRIPTION="A wrapper in C to make XOrg function as a proper systemd unit"
HOMEPAGE="https://github.com/sofar/xorg-launch-helper"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

DEPEND="sys-apps/systemd
	x11-base/xorg-server"
RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=(
		--with-systemduserunitdir="$(systemd_get_userunitdir)"
	)
	autotools-utils_src_configure
}

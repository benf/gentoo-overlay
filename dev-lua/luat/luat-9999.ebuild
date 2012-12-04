# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://gitorious.org/luat/luat.git"
AUTOTOOLS_AUTORECONF=1

inherit autotools autotools-utils git

DESCRIPTION="Linux C-library for lua to receive systeminformation"
HOMEPAGE="https://gitorious.org/luat/luat"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/lua
	sys-apps/lm_sensors"

RDEPEND="${DEPEND}"

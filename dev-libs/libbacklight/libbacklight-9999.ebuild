# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://anongit.freedesktop.org/libbacklight"

inherit autotools autotools-utils git-2

DESCRIPTION="Linux backlight interface library"
HOMEPAGE="http://cgit.freedesktop.org/libbacklight/"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=">=x11-libs/libpciaccess-0.10.0
	x11-libs/libdrm"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/0001-Link-against-libpciaccess.patch"
	"${FILESDIR}/0002-Add-libdrm-dependency.patch"
)

src_prepare()
{
	autotools-utils_src_prepare
	mkdir m4
	eautoreconf
}

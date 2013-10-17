# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://gitorious.org/cmumble/cmumble.git"
AUTOTOOLS_AUTORECONF=1

inherit autotools autotools-utils git-2

DESCRIPTION="Curses based mumble client"
HOMEPAGE="https://gitorious.org/cmumble"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/protobuf-c[protoc]
	>=dev-libs/glib-2.28:2
	net-libs/glib-networking[ssl]
	media-libs/gstreamer:0.10
	media-libs/celt
	media-libs/gst-plugins-base:0.10
	media-libs/gst-plugins-good:0.10
	media-plugins/gst-plugins-celt:0.10"

RDEPEND="${DEPEND}"

PATCHES=(
	# Fix Access violation by gst-inspect
	"${FILESDIR}/${P}-Remove-Gstreamer-element-check.patch"
)

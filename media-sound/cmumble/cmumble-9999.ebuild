# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="https://git.bnfr.net/cmumble"
AUTOTOOLS_AUTORECONF=1

inherit autotools autotools-utils git-2

DESCRIPTION="Curses based mumble client"
HOMEPAGE="https://git.bnfr.net/cmumble"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/protobuf-c
	>=dev-libs/glib-2.28:2
	net-libs/glib-networking[ssl]
	media-libs/gstreamer:0.10
	media-libs/celt:0.5.1
	media-libs/gst-plugins-base:0.10
	media-libs/gst-plugins-good:0.10
	media-plugins/gst-plugins-celt:0.10"

RDEPEND="${DEPEND}"

PATCHES=(
	# Fix Access violation by gst-inspect
	"${FILESDIR}/${P}-Remove-Gstreamer-element-check.patch"
)

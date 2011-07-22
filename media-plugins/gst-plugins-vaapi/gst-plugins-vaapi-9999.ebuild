# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="http://code.splitted-desktop.com/git/gstreamer-vaapi.git"
EGIT_BOOTSTRAP="echo 'EXTRA_DIST =' > gtk-doc.make; eautoreconf"

inherit autotools autotools-utils git-2

MY_PN="gstreamer-vaapi"
DESCRIPTION="GStreamer VA-API plugins"
HOMEPAGE="http://www.splitted-desktop.com/~gbeauchesne/gst-plugins-vaapi/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="dev-libs/glib:2
	virtual/opengl
	x11-libs/libX11	
	>=media-libs/gstreamer-0.10.0
	>=media-libs/gst-plugins-base-0.10.16
	x11-libs/libva
	>=virtual/ffmpeg-0.6[vaapi]"

RDEPEND="${DEPEND}"

DOCS=(AUTHORS README COPYING NEWS)

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	local myeconfargs=(
		--enable-glx
		--enable-vaapi-glx
		--enable-vaapisink-glx
	)
	autotools-utils_src_configure
}

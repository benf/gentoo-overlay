# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://anongit.freedesktop.org/~krh/wayland"
EGIT_BOOTSTRAP="eautoreconf"

inherit autotools autotools-utils git

DESCRIPTION="Wayland is a nano display server"
HOMEPAGE="http://groups.google.com/group/wayland-display-server"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="=x11-libs/cairo-9999[opengl,drm]
	=x11-libs/libxkbcommon-9999
	=x11-libs/libdrm-9999[libkms]
	=media-libs/mesa-99999999[gles1,gles2]
	media-libs/libpng
	x11-libs/gtk+
	>=sys-fs/udev-136
	x11-libs/libxcb
	dev-libs/glib:2
	app-text/poppler
	dev-libs/libffi"

RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

EGIT_PATCHES=(
	"${FILESDIR}/${P}-destdir.patch"
	"${FILESDIR}/${P}-install-bins.patch"
	"${FILESDIR}/${P}-nodoc.patch"
	"${FILESDIR}/${P}-linking.patch"
)

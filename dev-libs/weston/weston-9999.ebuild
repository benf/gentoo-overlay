# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://anongit.freedesktop.org/wayland/weston"
AUTOTOOLS_AUTORECONF=1

inherit autotools autotools-utils git-2

DESCRIPTION="demos for wayland the (compositing) display server library"
HOMEPAGE="http://wayland.freedesktop.org"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+poppler +svg +clients +simple-clients +weston-launch systemd
	+drm +x11 +compositor-wayland"

DEPEND="dev-libs/wayland
	media-libs/mesa[gles2,egl]
	x11-libs/pixman
	media-libs/libpng
	systemd? ( sys-apps/systemd )
	weston-launch? ( virtual/pam )
	drm? (
		>=virtual/udev-136
		>=x11-libs/libdrm-2.4.25
		media-libs/mesa[gbm]
		sys-libs/mtdev
	)
	x11? (
		x11-libs/libxcb
		x11-libs/libX11
	)
	compositor-wayland? (
		media-libs/mesa[wayland]
	)
	clients? (
		media-libs/mesa[wayland]
		dev-libs/glib:2
		media-libs/libjpeg-turbo
		>=x11-libs/cairo-1.11.3[opengl]
		|| ( x11-libs/gdk-pixbuf:2 <x11-libs/gtk+-2.20:2 )
		=x11-libs/libxkbcommon-9999
		poppler? ( app-text/poppler[cairo] )
	)
	simple-clients? ( media-libs/mesa[wayland] )
	svg? ( gnome-base/librsvg )"

RDEPEND="${DEPEND}"

# FIXME: add with-poppler to wayland configure
# FIXME: make systemd non-automagic
myeconfargs=(
	# prefix with "weston-" if not already
	"--program-transform-name='/^weston/!s/^/weston-/'"
	$(use_enable clients)
	$(use_enable simple-clients)
	$(use_enable drm drm-compositor)
	$(use_enable x11 x11-compositor)
	$(use_enable compositor-wayland wayland-compositor)
	$(use_enable weston-launch)
	--enable-setuid-install
)

src_prepare()
{
	sed -i -e "s/noinst_PROGRAMS =/bin_PROGRAMS +=/" \
		{src,clients}"/Makefile.am" || \
		die "sed {src,clients}/Makefile.am failed!"
	autotools-utils_src_prepare
}

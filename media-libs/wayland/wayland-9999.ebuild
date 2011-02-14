# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://anongit.freedesktop.org/wayland"
EGIT_BOOTSTRAP="eautoreconf"

inherit autotools autotools-utils git

DESCRIPTION="Wayland is a protocol and library for a (compositing) display server"
HOMEPAGE="http://wayland.freedesktop.org"
SRC_URI=""

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clients +poppler +svg"

DEPEND=">=x11-libs/cairo-1.10.0[opengl]
	media-libs/mesa[gles]
	clients? ( media-libs/mesa[gles,wayland] )
	x11-libs/pixman
	=x11-libs/libxkbcommon-9999
	=x11-libs/libdrm-9999[libkms]
	x11-libs/gtk+:2
	>=sys-fs/udev-136
	x11-libs/libxcb
	dev-libs/glib:2
	poppler? ( app-text/poppler[cairo] )
	svg? ( gnome-base/librsvg )
	dev-libs/libffi
	dev-libs/expat"

RDEPEND="${DEPEND}"

# FIXME: add with-poppler to wayland configure
myeconfargs=(
	"--program-prefix=wayland-"
)

src_prepare()
{
	sed -i -e "/PROGRAMS/s/noinst/bin/" \
		{compositor,clients}"/Makefile.am" || \
		die "sed {compositor,clients}/Makefile.am failed!"

	use clients || sed -i -e "/SUBDIRS/s/clients//" Makefile.am || \
		die "sed Makefile.am failed!"

	git_src_prepare
}

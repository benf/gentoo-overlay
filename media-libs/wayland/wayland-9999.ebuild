# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://anongit.freedesktop.org/wayland"
EGIT_BOOTSTRAP="eautoreconf"

inherit autotools autotools-utils git

DESCRIPTION="Wayland is a nano display server"
HOMEPAGE="http://groups.google.com/group/wayland-display-server"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+poppler"

DEPEND=">=x11-libs/cairo-1.10.0[opengl]
	media-libs/mesa[gles]
	=x11-libs/libxkbcommon-9999
	=x11-libs/libdrm-9999[libkms]
	x11-libs/gtk+:2
	>=sys-fs/udev-136
	x11-libs/libxcb
	dev-libs/glib:2
	poppler? ( app-text/poppler[cairo] )
	dev-libs/libffi
	dev-libs/expat"

RDEPEND="${DEPEND}"

EGIT_PATCHES=(
)

src_prepare()
{
	sed -i -e "/PROGRAMS/s/noinst/bin/" \
		{compositor,clients}"/Makefile.am" || \
		die "sed {compositor,clients}/Makefile.am failed!"

	if ! use poppler ; then
		sed -i \
			-e '/^view/d' \
			-e 's/view//' \
			-e 's/$(POPPLER_\(CFLAGS\|SOURCES\))//' \
			"clients/Makefile.am" || die
		sed -i '/POPPLER/d' configure.ac || die
	fi
	git_src_prepare
}

src_install()
{
	autotools-utils_src_install
	mkdir -p "${D}/usr/bin"
	cd "${D}/usr/bin"
	for bin in $(ls -1)
	do
		mv "${bin}" "wayland_${bin}"
	done
	insinto /etc/udev/rules.d
	doins ${S}/compositor/70-wayland.rules
}

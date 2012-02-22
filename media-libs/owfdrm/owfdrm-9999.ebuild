# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://anongit.freedesktop.org/~bnf/owfdrm"
AUTOTOOLS_AUTORECONF=1

inherit autotools autotools-utils git-2

DESCRIPTION="OpenWF Display Implementation on KMS/DRM"
HOMEPAGE="http://cgit.freedesktop.org/~bnf/owfdrm/"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="sys-fs/udev
	x11-libs/libdrm
	media-libs/mesa[egl]"

RDEPEND="${DEPEND}"

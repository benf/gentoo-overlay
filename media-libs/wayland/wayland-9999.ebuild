# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://anongit.freedesktop.org/wayland/wayland"
EGIT_BOOTSTRAP="eautoreconf"

inherit autotools autotools-utils git-2

DESCRIPTION="wayland is a protocol and library for a (compositing) display server"
HOMEPAGE="http://wayland.freedesktop.org"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="dev-libs/libffi
	dev-libs/expat"

RDEPEND="${DEPEND}"

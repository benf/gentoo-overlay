# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
EGIT_REPO_URI="git://anongit.freedesktop.org/~daniels/kbproto"
EGIT_BOOTSTRAP="eautoreconf"

inherit autotools-utils autotools git

DESCRIPTION="X.Org KB protocol headers"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="!<x11-libs/libxkbfile-1.0.6-r1"
DEPEND="${RDEPEND}"

PDEPEND="=x11-libs/libxkbfile-1.0.6-r1"

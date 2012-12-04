# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit gst-plugins-bad

KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/celt
	>=media-libs/gst-plugins-base-0.10.29"
DEPEND="${RDEPEND}"

# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit eutils qt4

DESCRIPTION="Pencil is an animation/drawing software"
HOMEPAGE="http://www.les-stooges.org/pascal/pencil/"
SRC_URI="mirror://sourceforge/${PN}-planner/${P}-src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( x11-libs/qt-gui:4 >=x11-libs/qt-4.2:4 )
	>=media-libs/ming-0.4.0_beta1"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-source"

src_compile()
{
	eqmake4 || die "qmake failed"
	emake || die "make failed"
}

src_install()
{
	dobin Pencil ${PN}
	doicon icons/${PN}.png || die "Failed to install icon"
	make_desktop_entry ${PN} Pencil ${PN} \
		"Graphics;2DGraphics;VectorGraphics" || \
		die "Failed to create a shourtcut"
}

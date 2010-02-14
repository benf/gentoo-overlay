# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion qt4
EAPI="1"

ESVN_REPO_URI="svn://labs.trolltech.com/svn/styles"
ESVN_PROJECT="gtkstyle"

DESCRIPTION="make QT 4.x appplications look like native GTK+"
HOMEPAGE="http://labs.trolltech.com/page/Projects/Styles/GtkStyle"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.0
		x11-libs/qt-gui:4"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

src_compile() {
	cd gtkstyle
	eqmake4 qgtkstyle.pro || die "qmake failed"
	emake || die "make failed"
}

src_install() {
	cd gtkstyle
	emake INSTALL_ROOT="${D}" install || die "make install failed"
}


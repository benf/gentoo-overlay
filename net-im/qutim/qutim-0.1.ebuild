# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit eutils qt4
MY_PN="${PN/im/IM}"

DESCRIPTION="New Instant Messenger (ICQ) written in C++ with Qt."
HOMEPAGE="http://www.qutim.org"
LICENSE="GPL-2"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="x11-libs/qt-gui:4"
DEPEND="${RDEPEND}"
QT4_BUILT_WITH_USE_CHECK="png" # gif"

S="${WORKDIR}/${MY_PN}"

src_compile() {
	if use debug; then
		CFLAGS="-O0 -g -ggdb"
		CXXFLAGS="${CFLAGS}"
	fi

	eqmake4 ${MY_PN}.pro || die "eqmake4 failed"
	emake || die "emake failed"
}

src_install(){
	into /usr
	dobin ${MY_PN} || die "Installation failed"

	# Creating Desktop Entry
	doicon icons/qutim_64.png || die "Failed to install icon"
	make_desktop_entry qutIM qutIM qutim_64.png "Network;InstantMessaging;Qt" || die "Failed to create a shourtcut"
}


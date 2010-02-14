# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN=${PN/-bin}
DESCRIPTION="Decoder for onlinetvrecorder.com"
HOMEPAGE="http://www.onlinetvrecorder.com/"
FILE="${PN}-linux-static-v${PV}"
SRC_URI="http://www.onlinetvrecorder.com/downloads/${FILE}.tar.bz2"
LICENSE="as-is"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="X"

RDEPEND="X? ( gnome-base/libglade
		dev-python/pygtk )"
DEPEND=""

src_compile() {
	:;
}

S="${WORKDIR}/${FILE}"
src_install() {
	dobin otrdecoder
	if use X; then
		insinto /usr/share/${MY_PN}
		doins decoder.glade

		sed -i -e "s:join(decoderpath,'decoder.glade'):join('/usr/share/${MY_PN}/','decoder.glade'):" \
			otrdecoder-gui
		dobin otrdecoder-gui
	fi

	dodoc README.OTR
}

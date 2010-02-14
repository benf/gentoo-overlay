# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Lightweight X11 desktop panel for LXDE"
HOMEPAGE="http://lxde.sourceforge.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa wifi"

RDEPEND=">=x11-libs/gtk+-2.6.0
	virtual/libintl
	alsa? ( media-libs/alsa-lib )
	wifi? ( net-wireless/wireless-tools )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	>=dev-util/pkgconfig-0.9.0"

src_unpack() {
	unpack ${A}
	cd "${S}/src/plugins"
#	epatch "${FILESDIR}/${P}-icons.patch"
}

src_compile() {
	econf --disable-dependency-tracking \
		$(use_enable alsa) \
		$(use_enable wifi libiw) || die "econf failed"
	emake || die "emake failed"
}
src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README
}

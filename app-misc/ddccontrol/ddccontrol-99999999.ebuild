# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://dccontrol.git.sourceforge.net/gitroot/ddccontrol/${PN}"
EGIT_BOOTSTRAP="_autogen"

inherit autotools autotools-utils git

DESCRIPTION="DDCControl allows control of monitor parameters via DDC"
HOMEPAGE="http://ddccontrol.sourceforge.net/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk gnome doc nls"

RDEPEND="dev-libs/libxml2:2
	gtk? ( >=x11-libs/gtk+-2.4:2 )
	gnome? ( >=gnome-base/gnome-panel-2.10 )
	sys-apps/pciutils
	nls? ( sys-devel/gettext )
	>=app-misc/ddccontrol-db-99999999"
DEPEND="${RDEPEND}
	dev-perl/XML-Parser
	dev-util/intltool
	doc? ( >=app-text/docbook-xsl-stylesheets-1.65.1
		   >=dev-libs/libxslt-1.1.6
	       app-text/htmltidy )
	sys-kernel/linux-headers"

DOCS=(AUTHORS ChangeLog NEWS README TODO)

_autogen() {
	mkdir m4
	echo 'AM_GNU_GETTEXT_VERSION(0.16.1)' >> configure.ac
	eautopoint --force
	intltoolize --force --copy --automake
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc)
		$(use_enable gtk gnome)
		$(use_enable gnome gnome-applet)
		$(use_enable nls)
	)

	autotools-utils_src_configure
}

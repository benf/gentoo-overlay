# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
EGIT_REPO_URI="git://dccontrol.git.sourceforge.net/gitroot/ddccontrol/${PN}"
EGIT_BOOTSTRAP="_autogen"

inherit autotools autotools-utils git

DESCRIPTION="DDCControl monitor database"
HOMEPAGE="http://ddccontrol.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="nls? ( sys-devel/gettext )"
DEPEND="${RDEPEND}
		dev-util/intltool
		dev-perl/XML-Parser"

DOCS=(AUTHORS ChangeLog NEWS README)

AUTOTOOLS_IN_SOURCE_BUILD=1

_autogen() {
	mkdir m4
		echo 'AM_GNU_GETTEXT_VERSION(0.16.1)' >> configure.ac
		eautopoint --force
		intltoolize --force --copy --automake
		eautoreconf
}

src_prepare () {
	# Touch db/options.xml.h, so it is not rebuilt
	touch db/options.xml.h
}

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
	)
	autotools-utils_src_configure
}

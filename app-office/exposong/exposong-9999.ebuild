# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
EHG_REPO_URI="https://code.google.com/p/exposong/"

PYTHON_USE_WITH="xml"
inherit python distutils fdo-mime mercurial

DESCRIPTION="ExpoSong is a worship presentation software."
HOMEPAGE="http://exposong.org"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-python/pygtk
	dev-python/pycairo"
RDEPEND="${DEPEND}"

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

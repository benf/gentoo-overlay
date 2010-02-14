# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="choKolate"

DESCRIPTION="a smooth, clean and chocolate coloured theme"
HOMEPAGE="http://narf41.deviantart.com/art/choKolate-149537424"
SRC_URI="http://fc06.deviantart.net/fs71/f/2010/007/c/b/choKolate_by_narf41.zip"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/share/apps/QtCurve/
	doins choKolate.qtcurve

	insinto /usr/share/apps/color-schemes/
	doins ChoKolate.colors

	#insinto /usr/share/apps/kwin/
	

}

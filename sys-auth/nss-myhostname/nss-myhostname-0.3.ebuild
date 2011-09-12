# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools-utils

DESCRIPTION="$PN provides host name resolution for the locally system hostname"
HOMEPAGE="http://0pointer.de/lennart/projects/nss-myhostname/"
SRC_URI="http://0pointer.de/lennart/projects/$PN/$P.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

pkg_postinst() {
	einfo 'To activate the NSS modules you have to edit /etc/nsswitch.conf'
	einfo 'and add myhostname to the line starting with "hosts:"'
	einfo
	einfo 'It is recommended to put myhostname last in the nsswitch.conf line'
	einfo 'to make sure that this mapping is only used as fallback,'
	einfo 'and any DNS or /etc/hosts based mapping takes precedence.'
}

# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/adtool/adtool-1.3-r1.ebuild,v 1.6 2009/05/11 18:51:54 dertobi123 Exp $

EAPI=3

inherit autotools-utils

DESCRIPTION="adtool is a Unix command line utility for Active Directory administration"
SRC_URI="http://gp2x.org/adtool/${P}.tar.gz"
HOMEPAGE="http://gp2x.org/adtool/"

KEYWORDS="~amd64 ppc ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="ssl kerberos"

DEPEND="net-nds/openldap[kerberos=]
	ssl? ( dev-libs/openssl )"
RDEPEND=""

src_prepare()
{
	use kerberos && epatch "${FILESDIR}/adtool-kerberos.patch"
	autotools-utils_src_prepare
}


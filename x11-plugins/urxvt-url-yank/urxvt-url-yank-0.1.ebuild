# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EGIT_REPO_URI="git://tachyon.jukie.net/urxvt"
inherit git

DESCRIPTION="mouse free url yanking in urxvt"
HOMEPAGE="http://www.jukie.net/~bart/blog/urxvt-url-yank"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-terms/rxvt-unicode"
RDEPEND="${DEPEND}
	x11-misc/xclip"

src_install()
{
	dodir /usr/lib/urxvt/perl/
	make INSTALL_DIR="${D}/usr/lib/urxvt/perl/" install
}

pkg_postinst()
{
	elog 'You should add the following to $HOME/.Xdefaults:'
	elog 'URxvt.keysym.M-u: perl:mark-yank-urls:activate_mark_mode'
	elog 'URxvt.perl-ext: selection,mark-yank-urls'
}

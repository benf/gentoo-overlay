# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/teamspeak2-client-bin/teamspeak2-client-bin-2.0.32.60-r3.ebuild,v 1.22 2009/08/26 07:58:44 ssuominen Exp $

MY_PV=rc2_2032
inherit eutils

DESCRIPTION="The TeamSpeak voice communication tool"
HOMEPAGE="http://www.goteamspeak.com"
SRC_URI="ftp://ftp.freenet.de/pub/4players/teamspeak.org/releases/ts2_client_${MY_PV}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libXt
	x86? ( || ( media-libs/jpeg-compat <media-libs/jpeg-7 ) )
	amd64? ( >=app-emulation/emul-linux-x86-baselibs-1
		>=app-emulation/emul-linux-x86-xlibs-1 )"
DEPEND=""

QA_TEXTRELS="opt/teamspeak2-client/*.so"
RESTRICT="strip test"

S=${WORKDIR}/ts2_client_${MY_PV}/setup.data/image

src_compile() { :; }

src_install() {
	local dest=/opt/teamspeak2-client

	newdoc Readme.txt README
	dodoc client_sdk/SDK_readme.txt
	dohtml manual/*

	into /opt
	dobin "${FILESDIR}"/TeamSpeak
	dosed "s:%installdir%:/opt/teamspeak2-client:g" /opt/bin/TeamSpeak

	exeinto ${dest}
	doexe TeamSpeak.bin *.so*

	insinto ${dest}/sounds
	doins sounds/*

	insinto ${dest}/client_sdk
	exeinto ${dest}/client_sdk
	doins client_sdk/*.pas client_sdk/*.dpr
	doexe client_sdk/tsControl client_sdk/*.so*

	newicon icon.xpm teamspeak.xpm
	make_desktop_entry TeamSpeak TeamSpeak teamspeak

	# Install a teamspeak.protocol file for kde/konqueror to accept
	# teamspeak:// links
	insinto /usr/share/services/
	doins "${FILESDIR}"/teamspeak.protocol

	# Fix bug #489010
	dosym /usr/share/doc/${PF}/html ${dest}/manual
}

pkg_postinst() {
	elog "Please Note: The new Teamspeak2 Release Candidate 2 Client"
	elog "will not be able to connect to any of the *old* rc1 servers."
	elog "if you get 'Bad response' from your server check if your"
	elog "server is running rc2, which is a version >= 2.0.19.16."
	elog "Also note this release supports the new speex codec, "
	elog "so if you got unsupported codec messages, you need this :D"
	echo
	elog "Note: If you just upgraded from a version less than 2.0.32.60-r1,"
	elog "your users' config files will incorrectly point to non-existant"
	elog "soundfiles because they've been moved from their old location."
	elog "You may want to perform the following commands:"
	elog "# mkdir /usr/share/teamspeak2-client"
	elog "# ln -s /opt/teamspeak2-client/sounds /usr/share/teamspeak2-client/sounds"
	elog "This way, each user won't have to modify their config files to"
	elog "reflect this move."
}

# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils fdo-mime versionator

MY_PN=PacketTracer
MY_PV=$(delete_all_version_separators)
MY_P=${MY_PN}${MY_PV}

DESCRIPTION="Cisco's Packet Tracer"
HOMEPAGE="http://cisco.netacad.net"
SRC_URI="http://cisco.netacad.net/cnams/resourcewindow/noncurr/downloadTools/app_files/${MY_P}.tar.gz"

LICENSE="cisco-eula"
SLOT="0"
KEYWORDS="~x86 amd64"
IUSE=""

DEPEND="app-arch/gzip"
RDEPEND="${DEPEND}
	media-libs/freetype:2
	app-arch/unzip
	app-arch/zip
	x86? (
		x11-libs/qt-gui[qt3support,accessibility]
		x11-libs/qt-script
		x11-libs/qt-assistant
		x11-libs/qt-webkit
	)
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-xlibs
	)"

RESTRICT="fetch strip mirror test"
PROPERTIES="interactive"

S=${WORKDIR}/${MY_P}

pkg_nofetch () {
	einfo "Please login on ${HOMEPAGE} and download"
	einfo " - ${SRC_URI}"
	einfo "and place it in ${DISTDIR}"
}

src_prepare() {
	echo "Read the following End User License Agreement \"EULA\" carefully."
	echo "You must accept the terms of this EULA to install and use Cisco Packet Tracer 5.2.1."

	read -p "Press the [ENTER] key to read the EULA." tmp
	less eula.txt

	read -p "Do you accept the term of the EULA? [Yes/no] " accept
	[[ "${accept}" =~ Yes|YES|yes|y|'' ]] || die "license not accepted."
}

src_install () {
	declare PKT_HOME="/opt/${PN}/"

	make_wrapper packettracer ./bin/PacketTracer5 ${PKT_HOME} ./lib32/

	newicon art/pkt.png "${PN}.png"
	make_desktop_entry packettracer "Cisco Packet Tracer" "${PN}" "Application;Network" \
			"MimeType=application/x-pkt;application/x-pka;application/x-pkz;"

	insinto /usr/share/mime/packages
	doins bin/Cisco-*.xml

	dosym /usr/share/doc/${PF}/html "${PKT_HOME}/help/default"

	dohtml -r help/default/*

	insinto "${PKT_HOME}"
	doins -r art/ backgrounds/ extensions/ LANGUAGES/ \
			saves/ Sounds/ templates/

	into "${PKT_HOME}"
	use amd64 && (
		declare ABI=x86
		dolib.so lib/*.so*
		#dolib.so lib/libQt3Support.so* lib/libQtSql.so*
	)

	dobin bin/linguist
	dobin bin/PacketTracer5

	insinto "${PKT_HOME}/bin"
	doins bin/PT.conf
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

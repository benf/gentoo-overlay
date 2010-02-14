# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="EeePC's AsusLauncher Utility"
HOMEPAGE="http://update.eeepc.asus.com/"

asus_mirror="http://update.eeepc.asus.com/p900/pool/"

packages=( "asus-icewm-config_1.52-1_all.deb"
	"asus-icons_3.137-1_i386.deb"
	"asus-launcher_1%253a0.142-1_i386.deb"
	"asus-launcher-config_1.0.2-1_all.deb" )

SRC_URI="amd64? ( "${asus_mirror}libstartup-notification0_0.8-2_i386.deb" )"

for package in ${packages[@]}
do
	SRC_URI="${SRC_URI} ${asus_mirror}${package}"
done

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip mirror"

DEPEND="x86? (
		=x11-libs/qt-3*
		x11-libs/startup-notification
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXrandr
		x11-libs/libXcursor
		x11-libs/libXinerama
		x11-libs/libXft
		x11-libs/libXext
		x11-libs/libSM
		x11-libs/libICE
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXfixes
		media-libs/fontconfig
		media-libs/libmng
		media-libs/jpeg
		media-libs/libpng
		media-libs/freetype
		dev-libs/expat
	)"
RDEPEND="${DEPEND}
	x11-wm/icewm
	amd64? (
		>=app-emulation/emul-linux-x86-baselibs-1.0
		>=app-emulation/emul-linux-x86-qtlibs-1.0
		>=app-emulation/emul-linux-x86-xlibs-1.0
	)"

src_unpack()
{
	local x
	for x in ${A}
	do
		unpack "${x}" "./data.tar.gz"
		#rm -f control.tar.gz data.tar.gz debian-binary
	done
}

src_install()
{
	insinto /usr/share/icewm
	exeinto /usr/share/icewm

	doins -r usr/share/icewm/* etc/X11/icewm/*

	# we need a startup file (asus doenst ship this)
	doexe "${FILESDIR}/startup"

	# fixing terminal and default theme
	echo 'Theme="AsusSunset/default.theme"' > "${D}/usr/share/icewm/theme"
	dosed "s:x-terminal-emulator:urxvt:g" /usr/share/icewm/keys

	into /opt/xandros
	dobin opt/xandros/bin/*
	dosbin opt/xandros/sbin/*

	insinto /opt/xandros/share
	doins -r opt/xandros/share/*

	insinto /opt/xandros/share/AsusLauncher
	doins "${FILESDIR}/simpleui.rc"

	# we need 32 bit startup notification for amd64 :-!
	if use amd64 ; then
		insinto /usr/lib32
		insopts -m0755
		doins usr/lib/libstartup-notification-1.so.0.0.0
		dosym libstartup-notification-1.so.0.0.0 \
			/usr/lib32/libstartup-notification-1.so.0
	fi
}


# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# this ebuild is based on qt-embedded from qting-edge overlay

EAPI="2"

EGIT_REPO_URI="git://gitorious.org/~krh/qt/qt-wayland.git"
EGIT_BRANCH="lighthouse-wayland"
EGIT_PATCHES=( "${FILESDIR}/config-test-wayland.patch" )

inherit eutils multilib qt4-r2 git

DESCRIPTION="Qt4 wayland port"
HOMEPAGE="http://qt.gitorious.org/~krh/qt/qt-wayland"
SRC_URI=""

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="4"
KEYWORDS="-* ~amd64 ~x86"

IUSE="-accessibility debug -doc -cups -firebird +glib gif -mysql -nis -ssl
	-pch -phonon -postgres -qt3support -sqlite svg -vnc -webkit -xmlpatterns"

DEPEND=" || ( media-libs/wayland x11-libs/wayland )
	media-libs/libpng
	media-libs/jpeg
	media-libs/libmng
	media-libs/lcms
	sys-libs/zlib
	cups? ( net-print/cups )
	firebird? ( dev-db/firebird )
	gif? ( media-libs/giflib )
	mysql? ( virtual/mysql )
	ssl? ( dev-libs/openssl )
	postgres? ( virtual/postgresql-server )
	sqlite? ( dev-db/sqlite )"
RDEPEND="${DEPEND}"

pkg_setup() {
	# Set up installation directories
	QTBASEDIR=/usr/$(get_libdir)/${PN}
	QTPREFIXDIR=/usr/${PN}
	QTBINDIR=/usr/bin/${PN}
	QTLIBDIR=/usr/$(get_libdir)/${PN}
	QTPCDIR=/usr/$(get_libdir)/${PN}/pkgconfig
	QTDATADIR=/usr/share/${PN}
	QTDOCDIR=/usr/share/doc/${P}
	QTHEADERDIR=/usr/include/${PN}
	QTPLUGINDIR=${QTLIBDIR}/plugins
	QTSYSCONFDIR=/etc/${PN}
	QTTRANSDIR=${QTDATADIR}/translations
	QTEXAMPLESDIR=${QTDATADIR}/examples
	QTDEMOSDIR=${QTDATADIR}/demos
	#PLATFORM=$(qt_mkspecs_dir)
	PATH="${S}/bin:${PATH}"
	LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"
}

src_configure() {
	myconf="-prefix ${QTPREFIXDIR}  -bindir ${QTBINDIR}  -libdir ${QTLIBDIR} \
		-docdir ${QTDOCDIR} -headerdir ${QTHEADERDIR} -datadir ${QTDATADIR} \
		-sysconfdir ${QTSYSCONFDIR} -translationdir ${QTTRANSDIR} \
		-examplesdir ${QTEXAMPLESDIR} -demosdir ${QTDEMOSDIR} \
		-plugindir ${QTPLUGINDIR} -confirm-license -opensource"
	if use debug; then
		myconf="${myconf} -debug"
	else
		myconf="${myconf} -release"
	fi
	# add qt modules support
	! use qt3support && myconf="${myconf} -no-qt3support"
	! use xmlpatterns && myconf="${myconf} -no-xmlpatterns"
	! use svg && myconf="${myconf} -no-svg"
	! use phonon && myconf="${myconf} -no-phonon"
	! use webkit && myconf="${myconf} -no-webkit"
	! use glib && myconf="${myconf} -no-glib"
	! use gif && myconf="${myconf} -no-gif"
	! use ssl && myconf="${myconf} -no-openssl"
	! use cups && myconf="${myconf} -no-cups"
	! use pch && myconf="${myconf} -no-pch"
	! use nis && myconf="${myconf} -no-nis"
	! use accessibility && myconf="${myconf} -no-accessibility"

	# Database support
	use firebird && myconf="${myconf} -plugin-sql-ibase" || myconf="${myconf} -no-sql-ibase"
	use mysql && myconf="${myconf} -plugin-sql-mysql" || myconf="${myconf} -no-sql-mysql"
	use postgres && myconf="${myconf} -plugin-sql-psql" || myconf="${myconf} -no-sql-psql"
	use sqlite && myconf="${myconf} -plugin-sql-sqlite" || myconf="${myconf} -no-sql-sqlite"

	# video drivers
	use vnc && myconf="${myconf} -plugin-gfx-vnc" || myconf="${myconf} -no-gfx-vnc"
	myconf="${myconf} -plugin-gfx-transformed -qt-gfx-multiscreen"
	# disable unneeded video drivers
	myconf=$(echo "${myconf} -no-gfx-"{directfb,linuxfb,qvfb})

	myconf="${myconf} -no-largefile"

	myconf="${myconf} -nomake examples -nomake demos -nomake translations"
	! use doc && myconf="${myconf} -nomake docs"

	# these are the important options to enable wayland-platform building
	myconf="${myconf} -qpa -opengl es2"

	# not really needed, but maybe this cleans some stupid *.pro files up..
	eqmake4 projects.pro

	echo "./configure ${myconf}"
	./configure ${myconf} || die "configure failed"
}
src_compile() {
	
	export PATH="${S}/bin:${PATH}"
	export LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"

	qt4-r2_src_compile

	# dont know how to get these binaries unstripped yet
	find ${S} -name Makefile | xargs sed -i /STRIP/d || die
}

src_install() {

	qt4-r2_src_install

	if use doc; then
		insinto "${QTDOCDIR}" || die "insinto failed"
		doins -r "${S}"/doc/qch || die "doins failed"
		dohtml -r "${S}"/doc/html || die "dohtml failed"
	fi

	# remove qmake as it is not necessary and hard to build unstripped
	rm -rf "${D}/${QTBINDIR}/qmake"
}

pkg_postinst() {
	elog "You will need to set \$LD_LIBRARY_PATH to /usr/$(get_libdir)/${PN}"
	elog "and add '-platform wayland' to you qt-application;"
	elog "\texport LD_LIBRARY_PATH=\"/usr/$(get_libdir)/${PN}\""
	elog "\tqt-application -platform wayland"
}


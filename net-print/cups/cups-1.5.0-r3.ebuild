# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# See http://git.overlays.gentoo.org/gitweb/?p=dev/dilfridge.git;a=blob;f=net-print/cups/notes.txt;hb=HEAD
# for some notes about the ongoing work here
#

EAPI=3

PYTHON_DEPEND="python? 2:2.5"

inherit autotools eutils flag-o-matic multilib pam perl-module python versionator java-pkg-opt-2 systemd

MY_P=${P/_}
MY_PV=${PV/_}

DESCRIPTION="The Common Unix Printing System"
HOMEPAGE="http://www.cups.org/"
SRC_URI="mirror://easysw/${PN}/${MY_PV}/${MY_P}-source.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acl dbus debug gnutls java +jpeg kerberos ldap pam perl php +png python samba slp +ssl static-libs +threads +tiff usb X xinetd"

LANGS="da de es eu fi fr id it ja ko nl no pl pt pt_BR ru sv zh zh_TW"
for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

RDEPEND="
	app-text/libpaper
	acl? (
		kernel_linux? (
			sys-apps/acl
			sys-apps/attr
		)
	)
	dbus? ( sys-apps/dbus )
	java? ( >=virtual/jre-1.6 )
	jpeg? ( virtual/jpeg:0 )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap[ssl?,gnutls?] )
	pam? ( virtual/pam )
	perl? ( dev-lang/perl )
	php? ( dev-lang/php )
	png? ( >=media-libs/libpng-1.4.3 )
	slp? ( >=net-libs/openslp-1.0.4 )
	ssl? (
		gnutls? (
			dev-libs/libgcrypt
			>=net-libs/gnutls-2.11
		)
		!gnutls? ( >=dev-libs/openssl-0.9.8g )
	)
	tiff? ( >=media-libs/tiff-3.5.5 )
	usb? ( virtual/libusb:0 )
	X? ( x11-misc/xdg-utils )
	xinetd? ( sys-apps/xinetd )
	!net-print/cupsddk
"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
"

PDEPEND="
	app-text/ghostscript-gpl[cups]
	>=app-text/poppler-0.12.3-r3[utils]
"

# upstream includes an interactive test which is a nono for gentoo.
RESTRICT="test"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup lp
	enewuser lp -1 -1 -1 lp
	enewgroup lpadmin 106

	# python 3 is no-go
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	# various build time fixes
	epatch "${FILESDIR}/${PN}-1.4.4-dont-compress-manpages.patch"
	epatch "${FILESDIR}/${PN}-1.4.4-fix-install-perms.patch"
	epatch "${FILESDIR}/${PN}-1.4.4-nostrip.patch"
	epatch "${FILESDIR}/${PN}-1.4.4-php-destdir.patch"
	epatch "${FILESDIR}/${PN}-1.4.4-perl-includes.patch"
	epatch "${FILESDIR}/${PN}-1.4.8-largeimage.patch"
	# security fixes
	epatch "${FILESDIR}/${PN}-1.4.8-CVE-2011-3170.patch"

	epatch "${FILESDIR}/${P}-systemd-socket.patch"

	AT_M4DIR=config-scripts eaclocal
	eautoconf
}

src_configure() {
	export DSOFLAGS="${LDFLAGS}"

	# locale support
	strip-linguas ${LANGS}
	if [ -z "${LINGUAS}" ] ; then
		export LINGUAS=none
	fi

	local myconf
	if use ssl || use gnutls ; then
		myconf+="
			$(use_enable gnutls)
			$(use_enable !gnutls openssl)
		"
	else
		myconf+="
			--disable-gnutls
			--disable-openssl
		"
	fi

	# bug 352252, recheck for later versions if still necessary....
	if use gnutls && ! use threads ; then
		ewarn "The useflag gnutls requires also threads enabled. Switching on threads."
	fi
	if use gnutls || use threads ; then
		myconf+=" --enable-threads "
	else
		myconf+=" --disable-threads "
	fi

	econf \
		--libdir=/usr/$(get_libdir) \
		--localstatedir=/var \
		--with-cups-user=lp \
		--with-cups-group=lp \
		--with-docdir=/usr/share/cups/html \
		--with-languages="${LINGUAS}" \
		--with-pdftops=/usr/bin/pdftops \
		--with-system-groups=lpadmin \
		$(use_enable acl) \
		$(use_enable dbus) \
		$(use_enable debug) \
		$(use_enable debug debug-guards) \
		$(use_enable jpeg) \
		$(use_enable kerberos gssapi) \
		$(use_enable ldap) \
		$(use_enable pam) \
		$(use_enable png) \
		$(use_enable slp) \
		$(use_enable static-libs static) \
		$(use_enable tiff) \
		$(use_enable usb libusb) \
		$(use_with java) \
		$(use_with perl) \
		$(use_with php) \
		$(use_with python) \
		$(use_with xinetd xinetd /etc/xinetd.d) \
		--enable-libpaper \
		--disable-dnssd \
		$(systemd_with_unitdir) \
		${myconf}

	# install in /usr/libexec always, instead of using /usr/lib/cups, as that
	# makes more sense when facing multilib support.
	sed -i -e 's:SERVERBIN.*:SERVERBIN = "$(BUILDROOT)"/usr/libexec/cups:' Makedefs || die
	sed -i -e 's:#define CUPS_SERVERBIN.*:#define CUPS_SERVERBIN "/usr/libexec/cups":' config.h || die
	sed -i -e 's:cups_serverbin=.*:cups_serverbin=/usr/libexec/cups:' cups-config || die
}

src_compile() {
	emake || die "emake failed"

	if use perl ; then
		cd "${S}"/scripting/perl
		perl-module_src_prep
		perl-module_src_compile
	fi

	if use php ; then
		cd "${S}"/scripting/php
		emake || die "emake php failed"
	fi
}

src_install() {
	emake BUILDROOT="${D}" install || die "emake install failed"
	dodoc {CHANGES,CREDITS,README}.txt || die "dodoc install failed"

	if use perl ; then
		cd "${S}"/scripting/perl
		perl-module_src_install
		fixlocalpod
	fi

	if use php ; then
		cd "${S}"/scripting/php
		emake DESTDIR="${D}" install || die "emake install for php bindings failed"
	fi

	# clean out cups init scripts
	rm -rf "${D}"/etc/{init.d/cups,rc*,pam.d/cups}

	# install our init script
	local neededservices
	use dbus && neededservices+=" dbus"
	[[ -n ${neededservices} ]] && neededservices="need${neededservices}"
	cp "${FILESDIR}"/cupsd.init.d "${T}"/cupsd || die
	sed -i \
		-e "s/@neededservices@/$neededservices/" \
		"${T}"/cupsd || die
	doinitd "${T}"/cupsd || die "doinitd failed"

	# install our pam script
	pamd_mimic_system cups auth account

	if use xinetd ; then
		# correct path
		sed -i \
			-e "s:server = .*:server = /usr/libexec/cups/daemon/cups-lpd:" \
			"${D}"/etc/xinetd.d/cups-lpd || die
		# it is safer to disable this by default, bug #137130
		grep -w 'disable' "${D}"/etc/xinetd.d/cups-lpd || \
			{ sed -i -e "s:}:\tdisable = yes\n}:" "${D}"/etc/xinetd.d/cups-lpd || die ; }
		# write permission for file owner (root), bug #296221
		fperms u+w /etc/xinetd.d/cups-lpd || die "fperms failed"
	else
		rm -rf "${D}"/etc/xinetd.d
	fi

	keepdir /usr/libexec/cups/driver /usr/share/cups/{model,profiles} \
		/var/cache/cups /var/cache/cups/rss /var/log/cups /var/run/cups/certs \
		/var/spool/cups/tmp

	keepdir /etc/cups/{interfaces,ppd,ssl}

	# FIXME: dont collide with systemd-units
	dodir /etc/systemd/system/
	mv "${D}"/usr/lib/systemd/system/cups.service "${D}"/etc/systemd/system/

	use X || rm -r "${D}"/usr/share/applications

	# create /etc/cups/client.conf, bug #196967 and #266678
	echo "ServerName /var/run/cups/cups.sock" >> "${D}"/etc/cups/client.conf
}

pkg_postinst() {
	echo
	elog "For information about installing a printer and general cups setup"
	elog "take a look at: http://www.gentoo.org/doc/en/printing-howto.xml"
	echo
}

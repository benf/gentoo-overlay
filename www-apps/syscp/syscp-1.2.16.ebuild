# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils depend.apache

KEYWORDS="~x86 ~amd64"
DESCRIPTION="A PHP-based webhosting-oriented control panel for servers."
HOMEPAGE="http://www.syscp.org/"
LICENSE="GPL-2"
SLOT="0"
IUSE="sslserv bind"

SRC_URI="http://files.syscp.org/releases/tgz/${P}.tar.gz
	 http://files.syscp.org/releases/gentoo/${P}-sqlfile.tar.bz2
	 sslserv? ( bind? ( http://files.syscp.org/releases/gentoo/${P}-gentoo-config-bind-ssl.tar.bz2 ) !bind? ( http://files.syscp.org/releases/gentoo/${P}-gentoo-config-nodns-ssl.tar.bz2 ) )
	 !sslserv? ( bind? ( http://files.syscp.org/releases/gentoo/${P}-gentoo-config-bind.tar.bz2 ) !bind? ( http://files.syscp.org/releases/gentoo/${P}-gentoo-config-nodns.tar.bz2 ) )"

DEPEND="
	mail-mta/postfix
	sys-process/vixie-cron
	dev-db/mysql
	dev-lang/php
	dev-libs/cyrus-sasl
	net-libs/courier-authlib
	net-mail/courier-imap
	net-ftp/proftpd
	app-admin/webalizer
	bind? ( net-dns/bind )
	sslserv? ( dev-libs/openssl )"
need_apache

S="${WORKDIR}/${PN}"

pkg_setup() {
	# Check that the packages we depend upon are compiled
	# with the required USE flags for Gentoo-SysCP

	einfo
	einfo "Checking for required features ..."
	einfo

	# Generate PHP dependency checks
	local PHPDEPEND=""
	if useq apache2 ; then
		PHPDEPEND="apache2 cli ctype expat ftp gd memlimit mysql nls pcre posix session ssl tokenizer xml xsl zlib"
	else
		PHPDEPEND="apache cli ctype expat ftp gd memlimit mysql nls pcre posix session ssl tokenizer xml xsl zlib"
	fi

	if useq sslserv ; then
		if ! built_with_use =`best_version 'dev-lang/php'` ${PHPDEPEND} \
		|| ! built_with_use =`best_version 'net-www/apache'` ssl \
		|| ! built_with_use =`best_version 'dev-libs/cyrus-sasl'` crypt mysql ssl \
		|| ! built_with_use =`best_version 'mail-mta/postfix'` mysql sasl ssl \
		|| ! built_with_use =`best_version 'net-libs/courier-authlib'` crypt mysql \
		|| ! built_with_use =`best_version 'net-ftp/proftpd'` mysql ssl \
		|| ! built_with_use =`best_version '>=app-admin/webalizer-2.01.10-r12'` apache2 ; then
			eerror
			eerror "Gentoo-SysCP requires you to build the following packages with"
			eerror "the mentioned USE flags enabled, please make sure they are"
			eerror "indeed enabled and then re-emerge ${PF}."
			eerror
			eerror "dev-lang/php    ${PHPDEPEND}"
			eerror "net-www/apache   ssl"
			eerror "dev-libs/cyrus   crypt mysql ssl"
			eerror "mail-mta/postfix   mysql sasl ssl"
			eerror "net-libs/courier-authlib   crypt mysql"
			eerror "net-ftp/proftpd   mysql ssl"
			eerror ">=app-admin/webalizer-2.01.10-r12   apache2"
			eerror
			die "Required features for Gentoo-SysCP not found"
		fi
	else
		if ! built_with_use =`best_version 'dev-lang/php'` ${PHPDEPEND} \
		|| ! built_with_use =`best_version 'dev-libs/cyrus-sasl'` crypt mysql \
		|| ! built_with_use =`best_version 'mail-mta/postfix'` mysql sasl \
		|| ! built_with_use =`best_version 'net-libs/courier-authlib'` crypt mysql \
		|| ! built_with_use =`best_version 'net-ftp/proftpd'` mysql \
		|| ! built_with_use =`best_version '>=app-admin/webalizer-2.01.10-r12'` apache2 ; then
			eerror
			eerror "Gentoo-SysCP requires you to build the following packages with"
			eerror "the mentioned USE flags enabled, please make sure they are"
			eerror "indeed enabled and then re-emerge ${PF}."
			eerror
			eerror "dev-lang/php    ${PHPDEPEND}"
			eerror "dev-libs/cyrus-sasl   crypt mysql"
			eerror "mail-mta/postfix   mysql sasl"
			eerror "net-libs/courier-authlib   crypt mysql"
			eerror "net-ftp/proftpd   mysql"
			eerror ">=app-admin/webalizer-2.01.10-r12   apache2"
			eerror
			die "Required features for Gentoo-SysCP not found"
		fi
	fi

	# Create the user and group that will own the SysCP files
	einfo "Creating syscp user ..."
	enewgroup syscp 9995
	enewuser syscp 9995 -1 /var/www/syscp syscp

	# Create the user and group that will run the FTPd
	einfo "Creating syscpftpd user ..."
	enewgroup syscpftpd 9996
	enewuser syscpftpd 9996 -1 /var/www/syscpwebs syscpftpd

	# Create the user and group that will run the virtual MTA
	einfo "Creating vmail user ..."
	enewgroup vmail 9997
	enewuser vmail 9997 -1 /var/syscpvmail vmail
}

src_unpack() {
	unpack ${A}

	cd "${S}"

	# Delete userdata.inc.php to avoid overwriting
	rm -f "${S}/lib/userdata.inc.php" || die "Unable to delete userdata.inc.php"

	# Delete any mention of inserttask('4') if no Bind is used
	if ! use bind ; then
		find "${S}/" -type f -exec sed -e "s|inserttask('4');||g" -i {} \;
	fi
}

src_install() {
	# Install the SysCP files
	dodir "/var/www"
	cp -Rf "${S}/" "${D}/var/www/" || die "Installation of the SysCP files failed"

	# Installing modified admin_configfiles.php
	cp -f "${WORKDIR}/${PN}-${PV}-gentoo-admin_configfiles.php"* "${D}/var/www/syscp/admin_configfiles.php" || die "Unable to copy admin_configfiles.php"

	# Installing new Gentoo configfiles
	cp -Rf "${WORKDIR}/gentoo/" "${D}/var/www/syscp/templates/misc/configfiles/" || die "Unable to copy new Gentoo configfiles"

	# Move the SQL and configuration files to /usr/share/${PF} for the emerge installer
	dodir "/usr/share/${PF}"
	insinto "/usr/share/${PF}"
	doins "${WORKDIR}/${PN}-${PV}-"*"-db.sql"
	doins "${WORKDIR}/gentoo/"*"/"*

	# If Bind is to be used, change the reload path for it
	if useq bind ; then
		sed -e 's|/bin/true|/etc/init.d/named reload|g' -i "${D}/usr/share/${PF}/${PN}-${PV}-baseinstall-db.sql" || die "Unable to change reload path for Bind"
	fi

	# Apache1 compatibility
	if ! useq apache2 ; then
		sed -e 's|/etc/init.d/apache2 reload|/etc/init.d/apache reload|g' -i "${D}/usr/share/${PF}/${PN}-${PV}-baseinstall-db.sql" || die "Unable to change reload path for Apache"
		sed -e 's|/etc/apache2/|/etc/apache/|g' -i "${D}/usr/share/${PF}/${PN}-${PV}-baseinstall-db.sql" || die "Unable to change config dir for Apache"
	fi

	# Fix the permissions for the SysCP files
	chown syscp:apache "${D}/var/www/syscp" || die "Unable to fix user:group permissions"
	chown -R syscp:syscp "${D}/var/www/syscp" || die "Unable to fix user:group permissions"
	find "${D}/var/www/syscp" -type d -exec chmod 0755 {} \; || die "Unable to fix directory permissions"
	find "${D}/var/www/syscp" -type f -exec chmod 0644 {} \; || die "Unable to fix file permissions"
	chown root:0 "${D}/usr/share/${PF}" || die "Unable to fix user:group permissions"
	chown -R root:0 "${D}/usr/share/${PF}" || die "Unable to fix user:group permissions"
	find "${D}/usr/share/${PF}" -type d -exec chmod 0750 {} \; || die "Unable to fix directory permissions"
	find "${D}/usr/share/${PF}" -type f -exec chmod 0640 {} \; || die "Unable to fix file permissions"

	# Create the main directories for customer data
	keepdir "/var/www/syscpwebs"
	chown root:root "${D}/var/www/syscpwebs" || die "Unable to fix user:group permissions"
	chmod 0755 "${D}/var/www/syscpwebs" || die "Unable to fix directory permissionns"
	keepdir "/var/syscpvmail"
	chown vmail:vmail "${D}/var/syscpvmail" || die "Unable to fix user:group permissions"
	chmod 0750 "${D}/var/syscpvmail" || die "Unable to fix directory permissions"
	keepdir "/var/log/syscplogs"

}

pkg_postinst() {
	# Normalize permissions
	chown syscp:apache "${ROOT}/var/www/syscp" || die "Unable to fix user:group permissions"
	chmod 0750 "${ROOT}/var/www/syscp" || die "Unable to fix directory permissions"
	chown root:root "${ROOT}/var/www/syscpwebs" || die "Unable to fix user:group permissions"
	chmod 0755 "${ROOT}/var/www/syscpwebs" || die "Unable to fix directory permissions"
	chown vmail:vmail "${ROOT}/var/syscpvmail" || die "Unable to fix user:group permissions"
	chmod 0750 "${ROOT}/var/syscpvmail" || die "Unable to fix directory permissions"

	einfo
	einfo "Please run 'emerge --config =${PF}' to continue with"
	einfo "the basic setup of Gentoo-SysCP, *after* you have"
	einfo "setup your MySQL databases root user and password"
	einfo "like the MySQL ebuild tells you to do."
	einfo
}

pkg_config() {
	local proceedyesno1
	local servername
	local serverip
	local mysqlhost
	local mysqlaccesshost
	local mysqlrootuser
	local mysqlrootpw1
	local mysqlrootpw2
	local mysqlrootpw
	local mysqldbname
	local mysqlunprivuser
	local mysqlunprivpw1
	local mysqlunprivpw2
	local mysqlunprivpw
	local adminuser
	local adminpw1
	local adminpw2
	local adminpw
	local proceedyesno2

	ewarn "Gentoo-SysCP Basic Configuration"
	echo
	einfo "This will setup Gentoo-SysCP on your system, it will create and"
	einfo "populate the MySQL database, create and chmod the needed files"
	einfo "correctly and configure all services to work out-of-the-box"
	einfo "with Gentoo-SysCP, using a sane default configuration, and"
	einfo "start them, along with creating the correct Gentoo-SysCP Apache"
	einfo "VirtualHost for you."
	einfo "CAUTION: this will backup and then replace your services"
	einfo "configuration and restart them!"
	echo
	einfo "Do you want to proceed? [Y/N]"
	echo
	read -rp " > " proceedyesno1 ; echo
	if [[ ${proceedyesno1} == "Y" ]] || [[ ${proceedyesno1} == "y" ]] || [[ ${proceedyesno1} == "Yes" ]] || [[ ${proceedyesno1} == "yes" ]] ; then
		echo
	else
		echo
		die "User abort: not proceeding!"
	fi
	einfo "Enter the domain under wich SysCP shall be reached, this normally"
	einfo "is the FQDN (Fully Qualified Domain Name) of your system."
	einfo "If you don't know the FQDN of your system, execute 'hostname -f'."
	einfo "This installscript will try to guess your FQDN automatically if"
	einfo "you leave this field blank, setting it to the output of 'hostname -f'."
	echo
	read -rp " > " servername ; echo
	echo
	if [[ ${servername} == "" ]] ; then
		servername=`hostname -f`
	fi
	einfo "Enter the IP address of your system, under wich all"
	einfo "websites shall then be reached. This must be the same"
	einfo "IP address the domain you inserted above points to."
	einfo "You *must* set this to your correct IP address."
	echo
	read -rp " > " serverip ; echo
	echo
	if [[ ${serverip} == "" ]] ; then
		die "Abort: need correct IP address!"
	fi
	einfo "Enter the IP address of the MySQL server, if the MySQL"
	einfo "server is on the same machine, enter 'localhost' or"
	einfo "simply leave the field blank."
	echo
	read -rp " > " mysqlhost ; echo
	echo
	if [[ ${mysqlhost} == "" ]] ; then
		mysqlhost="localhost"
	fi
	if [[ ${mysqlhost} == "localhost" ]] ; then
		mysqlaccesshost="localhost"
	else
		mysqlaccesshost="${serverip}"
	fi
	einfo "Enter the username of the MySQL root user."
	einfo "The default is 'root'."
	echo
	read -rp " > " mysqlrootuser ; echo
	echo
	if [[ ${mysqlrootuser} == "" ]] ; then
		mysqlrootuser="root"
	fi
	einfo "Enter the password of the MySQL root user."
	echo
	read -rsp " > " mysqlrootpw1 ; echo
	echo
	if [[ ${mysqlrootpw1} == "" ]] ; then
		die "Abort: please insert a valid password!"
	fi
	einfo "Confirm the password of the MySQL root user."
	echo
	read -rsp " > " mysqlrootpw2 ; echo
	echo
	if [[ ${mysqlrootpw2} == "" ]] ; then
		die "Abort: please insert a valid password!"
	fi
	if [[ ${mysqlrootpw1} != ${mysqlrootpw2} ]] ; then
		die "Abort: the two passwords don't match!"
	else
		mysqlrootpw="${mysqlrootpw1}"
	fi
	einfo "Enter the name of the database you want to"
	einfo "use for SysCP. The default is 'syscp'."
	einfo "CAUTION: any database with that name will"
	einfo "be dropped!"
	echo
	read -rp " > " mysqldbname ; echo
	echo
	if [[ ${mysqldbname} == "" ]] ; then
		mysqldbname="syscp"
	fi
	einfo "Enter the username of the unprivileged"
	einfo "MySQL user you want SysCP to use."
	einfo "The default is 'syscp'."
	einfo "CAUTION: any user with that name will"
	einfo "be deleted!"
	echo
	read -rp " > " mysqlunprivuser ; echo
	echo
	if [[ ${mysqlunprivuser} == "" ]] ; then
		mysqlunprivuser="syscp"
	fi
	einfo "Enter the password of the unprivileged"
	einfo "MySQL user."
	echo
	read -rsp " > " mysqlunprivpw1 ; echo
	echo
	if [[ ${mysqlunprivpw1} == "" ]] ; then
		die "Abort: please insert a valid password!"
	fi
	einfo "Confirm the password of the unprivileged"
	einfo "MySQL user."
	echo
	read -rsp " > " mysqlunprivpw2 ; echo
	echo
	if [[ ${mysqlunprivpw2} == "" ]] ; then
		die "Abort: please insert a valid password!"
	fi
	if [[ ${mysqlunprivpw1} != ${mysqlunprivpw2} ]] ; then
		die "Abort: the two passwords don't match!"
	else
		mysqlunprivpw="${mysqlunprivpw1}"
	fi
	einfo "Enter the username of the admin user you"
	einfo "want in your SysCP panel."
	einfo "Default is 'admin'."
	echo
	read -rp " > " adminuser ; echo
	echo
	if [[ ${adminuser} == "" ]] ; then
		adminuser="admin"
	fi
	einfo "Enter the password of the SysCP admin user."
	echo
	read -rsp " > " adminpw1 ; echo
	echo
	if [[ ${adminpw1} == "" ]] ; then
		die "Abort: please insert a valid password!"
	fi
	einfo "Confirm the password of the SysCP admin user."
	echo
	read -rsp " > " adminpw2 ; echo
	echo
	if [[ ${adminpw2} == "" ]] ; then
		die "Abort: please insert a valid password!"
	fi
	if [[ ${adminpw1} != ${adminpw2} ]] ; then
		die "Abort: the two passwords don't match!"
	else
		adminpw="${adminpw1}"
	fi

	einfo "Adding MySQL server to 'default' runlevel ..."
	rc-update add mysql default

	einfo "(Re)Starting MySQL server ..."
	"${ROOT}/etc/init.d/mysql" restart

	einfo "Creating temporary work directory ..."
	rm -Rf "${ROOT}/tmp/syscp-install-by-emerge"
	mkdir -p "${ROOT}/tmp/syscp-install-by-emerge"
	chown root:0 "${ROOT}/tmp/syscp-install-by-emerge"
	chmod 0700 "${ROOT}/tmp/syscp-install-by-emerge"

	einfo "Preparing SQL database files ..."
	cp -f "${ROOT}/usr/share/${PF}/${PN}-${PV}-"*"-db.sql" "${ROOT}/tmp/syscp-install-by-emerge/"
	chown root:0 "${ROOT}/tmp/syscp-install-by-emerge/${PN}-${PV}-"*"-db.sql"
	chmod 0600 "${ROOT}/tmp/syscp-install-by-emerge/${PN}-${PV}-"*"-db.sql"
	sed -e "s|MYSQL_ACCESS_HOST|${mysqlaccesshost}|g" -i "${ROOT}/tmp/syscp-install-by-emerge/${PN}-${PV}-"*"-db.sql"
	sed -e "s|MYSQL_UNPRIV_USER|${mysqlunprivuser}|g" -i "${ROOT}/tmp/syscp-install-by-emerge/${PN}-${PV}-"*"-db.sql"
	sed -e "s|MYSQL_UNPRIV_PASSWORD|${mysqlunprivpw}|g" -i "${ROOT}/tmp/syscp-install-by-emerge/${PN}-${PV}-"*"-db.sql"
	sed -e "s|MYSQL_DATABASE_NAME|${mysqldbname}|g" -i "${ROOT}/tmp/syscp-install-by-emerge/${PN}-${PV}-"*"-db.sql"
	sed -e "s|SERVERNAME|${servername}|g" -i "${ROOT}/tmp/syscp-install-by-emerge/${PN}-${PV}-"*"-db.sql"
	sed -e "s|SERVERIP|${serverip}|g" -i "${ROOT}/tmp/syscp-install-by-emerge/${PN}-${PV}-"*"-db.sql"
	sed -e "s|ADMIN_USERNAME|${adminuser}|g" -i "${ROOT}/tmp/syscp-install-by-emerge/${PN}-${PV}-"*"-db.sql"
	sed -e "s|ADMIN_PASSWORD|${adminpw}|g" -i "${ROOT}/tmp/syscp-install-by-emerge/${PN}-${PV}-"*"-db.sql"

	einfo "Installing SQL database files ..."
	mysql -u ${mysqlrootuser} -p${mysqlrootpw} < "${ROOT}/tmp/syscp-install-by-emerge/${PN}-${PV}-baseinstall-db.sql"

	einfo "Deleting SQL database files ..."
	rm -f "${ROOT}/tmp/syscp-install-by-emerge/${PN}-${PV}-"*"-db.sql"

	einfo "Installing SysCP data file ..."
	rm -f "${ROOT}/var/www/syscp/lib/userdata.inc.php"
	touch "${ROOT}/var/www/syscp/lib/userdata.inc.php"
	chown syscp:apache "${ROOT}/var/www/syscp/lib/userdata.inc.php"
	chmod 0640 "${ROOT}/var/www/syscp/lib/userdata.inc.php"
	echo "<?php
//automatically generated userdata.inc.php for SysCP
\$sql['host']='${mysqlhost}';
\$sql['user']='${mysqlunprivuser}';
\$sql['password']='${mysqlunprivpw}';
\$sql['db']='${mysqldbname}';
\$sql['root_user']='${mysqlrootuser}';
\$sql['root_password']='${mysqlrootpw}';
?>" > "${ROOT}/var/www/syscp/lib/userdata.inc.php"

	if built_with_use =`best_version 'www-apps/syscp'` sslserv ; then
		einfo "Creating needed SSL certificates ..."
		einfo "Please enter the correct input when it's requested."
		einfo "ATTENTION: when you're requested to enter a"
		einfo "'Common Name' enter ${servername} ."

		# Create the directories where we'll store our SSL
		# certificates and set secure permissions on them
		mkdir -p "${ROOT}/etc/ssl/server"
		chown root:0 "${ROOT}/etc/ssl/server"
		chmod 0700 "${ROOT}/etc/ssl/server"

		# We first generate our Private Key
		openssl genrsa -des3 -out "${ROOT}/etc/ssl/server/${servername}.key" 2048

		# Now we generate our CSR (Certificate Signing Request)
		openssl req -new -key "${ROOT}/etc/ssl/server/${servername}.key" -out "${ROOT}/etc/ssl/server/${servername}.csr"

		# Create an unencrypted key, to avoid having to always enter
		# the passphrase when a service using it is restarted (eg. Apache)
		cp -f "${ROOT}/etc/ssl/server/${servername}.key" "${ROOT}/etc/ssl/server/${servername}.key.orig"
		openssl rsa -in "${ROOT}/etc/ssl/server/${servername}.key.orig" -out "${ROOT}/etc/ssl/server/${servername}.key"

		einfo "You can now submit ${ROOT}/etc/ssl/server/${servername}.csr"
		einfo "to an official CA (Certification Authority) to be"
		einfo "signed (with costs) or you can sign it yourself (free)."
		einfo "For more informations regarding SSL please visit:"
		einfo "http://httpd.apache.org/docs/2.0/ssl/ssl_intro.html"

		echo
		einfo "Do you want to self-sign your certificate? [Y/N]"
		echo
		read -rp " > " proceedyesno2 ; echo
		if [[ ${proceedyesno2} == "Y" ]] || [[ ${proceedyesno2} == "y" ]] || [[ ${proceedyesno2} == "Yes" ]] || [[ ${proceedyesno2} == "yes" ]] ; then
			echo
			# We now generate a self-signed certificate that will
			# be valid for 365 days
			openssl x509 -req -days 365 -in "${ROOT}/etc/ssl/server/${servername}.csr" -signkey "${ROOT}/etc/ssl/server/${servername}.key" -out "${ROOT}/etc/ssl/server/${servername}.crt"

			# We now create a file that contains both the Private Key
			# and the signed certificate, this is needed for Courier
			cat "${ROOT}/etc/ssl/server/${servername}.crt" "${ROOT}/etc/ssl/server/${servername}.key" > "${ROOT}/etc/ssl/server/${servername}.crt_and_key"
		else
			einfo "Note: if you let your certificate be signed by an official"
			einfo "CA please be sure to copy the certificate they gave you to"
			einfo "${ROOT}/etc/ssl/server/${servername}.crt before starting"
			einfo "and using any of the SSL enabled services."
			echo
			einfo "You'll also need to create a file that contains both the"
			einfo "Private Key and the signed certificate, this is needed for"
			einfo "Courier to work correctly."
			einfo "You can do this with the following command:"
			einfo "cat \"${ROOT}/etc/ssl/server/${servername}.crt\" \"${ROOT}/etc/ssl/server/${servername}.key\" > \"${ROOT}/etc/ssl/server/${servername}.crt_and_key\""
			echo
			einfo "Additionally, don't forget to set the correct file permissions"
			einfo "on your SSL files, you can do this with the following commands:"
			einfo "chown root:0 \"${ROOT}/etc/ssl/server/${servername}.\"*"
			einfo "chmod 0400 \"${ROOT}/etc/ssl/server/${servername}.\"*"
		fi

		# Set secure permissions for our SSL files
		chown root:0 "${ROOT}/etc/ssl/server/${servername}."*
		chmod 0400 "${ROOT}/etc/ssl/server/${servername}."*
	fi

	einfo "Writing Gentoo-SysCP vhost configuration ..."
	rm -f "${ROOT}/etc/apache${USE_APACHE2}/vhosts.d/95_${servername}.conf"
	touch "${ROOT}/etc/apache${USE_APACHE2}/vhosts.d/95_${servername}.conf"
	chown root:0 "${ROOT}/etc/apache${USE_APACHE2}/vhosts.d/95_${servername}.conf"
	chmod 0600 "${ROOT}/etc/apache${USE_APACHE2}/vhosts.d/95_${servername}.conf"

	if built_with_use =`best_version 'www-apps/syscp'` sslserv ; then

		echo "# Gentoo-SysCP SSL-enabled VirtualHost
<IfDefine SSL>
	<IfDefine SSL_SYSCP_VHOST>
		<IfModule mod_ssl.c>
			<VirtualHost ${serverip}:443>
				DocumentRoot \"/var/www/syscp\"
				ServerName ${servername}" >> "${ROOT}/etc/apache${USE_APACHE2}/vhosts.d/95_${servername}.conf"

		echo "				ErrorLog logs/syscp_ssl_error_log
				<IfModule mod_log_config.c>
					TransferLog logs/syscp_ssl_access_log
				</IfModule>
				SSLEngine on
				SSLCipherSuite ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP:+eNULL
				SSLCertificateFile /etc/ssl/server/${servername}.crt
				SSLCertificateKeyFile /etc/ssl/server/${servername}.key
				<Files ~ \"\.(cgi|shtml|phtml|php?)$\">
					SSLOptions +StdEnvVars
				</Files>
				<IfModule mod_setenvif.c>
					SetEnvIf User-Agent \".*MSIE.*\" nokeepalive ssl-unclean-shutdown \\
					downgrade-1.0 force-response-1.0
				</IfModule>
				<IfModule mod_log_config.c>
					CustomLog logs/syscp_ssl_request_log \\
					\"%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \\\"%r\\\" %b\"
				</IfModule>
				<Directory \"/var/www/syscp\">
					Order allow,deny
					allow from all
				</Directory>
			</VirtualHost>
		</IfModule>
	</IfDefine>

</IfDefine>

# Redirect to the SSL-enabled Gentoo-SysCP vhost
<IfDefine SSL_SYSCP_VHOST>
	<VirtualHost ${serverip}:80>
		RedirectPermanent / https://${servername}/index.php
	</VirtualHost>
</IfDefine>" >> "${ROOT}/etc/apache${USE_APACHE2}/vhosts.d/95_${servername}.conf"

	else

		echo "# Gentoo-SysCP VirtualHost
<IfDefine SYSCP_VHOST>
	<VirtualHost ${serverip}:80>
		DocumentRoot \"/var/www/syscp\"
		ServerName ${servername}" >> "${ROOT}/etc/apache${USE_APACHE2}/vhosts.d/95_${servername}.conf"

		echo "		<Directory \"/var/www/syscp\">
			Order allow,deny
			allow from all
		</Directory>
	</VirtualHost>
</IfDefine>" >> "${ROOT}/etc/apache${USE_APACHE2}/vhosts.d/95_${servername}.conf"

	fi

	# Automatical Apache configuration
	if built_with_use =`best_version 'www-apps/syscp'` sslserv ; then
		einfo "Attempting to edit ${ROOT}/etc/conf.d/apache${USE_APACHE2} to suit Gentoo-SysCP ..."
		sed -e "s|^APACHE${USE_APACHE2}_OPTS=\".*|APACHE${USE_APACHE2}_OPTS=\"-D SSL -D SSL_SYSCP_VHOST -D PHP5\"|g" -i "${ROOT}/etc/conf.d/apache${USE_APACHE2}" || ewarn "Unable to change APACHE${USE_APACHE2}_OPTS in ${ROOT}/etc/conf.d/apache${USE_APACHE2}, please change it manually to add '-D SSL -D SSL_SYSCP_VHOST -D PHP5'"
	else
		einfo "Attempting to edit ${ROOT}/etc/conf.d/apache${USE_APACHE2} to suit Gentoo-SysCP ..."
		sed -e "s|^APACHE${USE_APACHE2}_OPTS=\".*|APACHE${USE_APACHE2}_OPTS=\"-D SYSCP_VHOST -D PHP5\"|g" -i "${ROOT}/etc/conf.d/apache${USE_APACHE2}" || ewarn "Unable to change APACHE${USE_APACHE2}_OPTS in ${ROOT}/etc/conf.d/apache${USE_APACHE2}, please change it manually to add '-D SYSCP_VHOST -D PHP5'"
	fi

	einfo "Fix general Apache configuration to work with Gentoo-SysCP ..."
	sed -e "s|^\#ServerName localhost.*|ServerName ${servername}|g" -i "${ROOT}/etc/apache${USE_APACHE2}/httpd.conf" || ewarn "Please make sure that the ServerName directive in ${ROOT}/etc/apache${USE_APACHE2}/httpd.conf is set to a valid value!"
	sed -e "s|^ServerAdmin root\@localhost.*|ServerAdmin root\@${servername}|g" -i "${ROOT}/etc/apache${USE_APACHE2}/httpd.conf" || ewarn "Please make sure that the ServerAdmin directive in ${ROOT}/etc/apache${USE_APACHE2}/httpd.conf is set to a valid value!"
	sed -e "s|\*:80|${serverip}:80|g" -i "${ROOT}/etc/apache${USE_APACHE2}/vhosts.d/00_default_vhost.conf" || ewarn "Please make sure the NameVirtualHost and VirtualHost directives in ${ROOT}/etc/apache${USE_APACHE2}/vhosts.d/00_default_vhost.conf are set to the Gentoo-SysCP IP and Port 80!"

	# Automatical Bind configuration, if Bind is installed
	if built_with_use =`best_version 'www-apps/syscp'` bind ; then
		einfo "Add Gentoo-SysCP include to Bind configuration ..."
		echo "include \"/etc/bind/syscp_bind.conf\";" >> "${ROOT}/etc/bind/named.conf"
	fi

	# NSS-MySQL preparations
	#einfo "Modifying nsswitch.conf to use MySQL ..."
	#sed -e "s|compat|compat mysql|g" -i "${ROOT}/etc/nsswitch.conf"

	# Helper functions
	create_config_file() {
		if [[ -f "${ROOT}/${1}" ]] ; then
			einfo "Moving old ${ROOT}/${1} to ${ROOT}/${1}.bak and setting restrictive permissions ..."
			mv -f "${ROOT}/${1}" "${ROOT}/${1}.bak"
			chown root:0 "${ROOT}/${1}.bak"
			chmod 0400 "${ROOT}/${1}.bak"
		fi
		einfo "Installing ${ROOT}/${1} and setting permissions ..."
		rm -f "${ROOT}/${1}"
		touch "${ROOT}/${1}"
		if [[ -n "${CHOWN}" ]] ; then
			chown ${CHOWN} "${ROOT}/${1}"
		else
			chown root:0 "${ROOT}/${1}"
		fi
		if [[ -n "${CHMOD}" ]] ; then
			chmod ${CHMOD} "${ROOT}/${1}"
		else
			chmod 0600 "${ROOT}/${1}"
		fi
		if [[ -f "${ROOT}/tmp/syscp-install-by-emerge/${1//\//_}" ]] ; then
			cat "${ROOT}/tmp/syscp-install-by-emerge/${1//\//_}" > "${ROOT}/${1}"
		fi
	}

	srv_add_restart() {
		einfo "Adding ${1} to 'default' runlevel ..."
		rc-update add ${1} default
		einfo "(Re)Starting ${1} ..."
		"${ROOT}/etc/init.d/${1}" restart
	}

	# Prepare service configuration files

	cp -f "${ROOT}/usr/share/${PF}/etc_"* "${ROOT}/tmp/syscp-install-by-emerge/"
	chown root:0 "${ROOT}/tmp/syscp-install-by-emerge/etc_"*
	chmod 0600 "${ROOT}/tmp/syscp-install-by-emerge/etc_"*
	sed -e "s|<SERVERIP>|${serverip}|g" -i "${ROOT}/tmp/syscp-install-by-emerge/etc_"*
	sed -e "s|<SERVERNAME>|${servername}|g" -i "${ROOT}/tmp/syscp-install-by-emerge/etc_"*
	sed -e "s|<SQL_HOST>|${mysqlhost}|g" -i "${ROOT}/tmp/syscp-install-by-emerge/etc_"*
	sed -e "s|<SQL_DB>|${mysqldbname}|g" -i "${ROOT}/tmp/syscp-install-by-emerge/etc_"*
	sed -e "s|<SQL_UNPRIVILEGED_USER>|${mysqlunprivuser}|g" -i "${ROOT}/tmp/syscp-install-by-emerge/etc_"*
	sed -e "s|<SQL_UNPRIVILEGED_PASSWORD>|${mysqlunprivpw}|g" -i "${ROOT}/tmp/syscp-install-by-emerge/etc_"*
	sed -e "s|<VIRTUAL_UID_MAPS>|9997|g" -i "${ROOT}/tmp/syscp-install-by-emerge/etc_"*
	sed -e "s|<VIRTUAL_GID_MAPS>|9997|g" -i "${ROOT}/tmp/syscp-install-by-emerge/etc_"*
	sed -e "s|<VIRTUAL_MAILBOX_BASE>|/var/syscpvmail/|g" -i "${ROOT}/tmp/syscp-install-by-emerge/etc_"*

	# Automatical services configuration

	einfo "Configuring Apache ..."
	create_config_file "etc/apache${USE_APACHE2}/vhosts.d/99_syscp-vhosts.conf"
	create_config_file "etc/apache${USE_APACHE2}/diroptions.conf"

	einfo "Configuring Gentoo-SysCP cronjob ..."
	create_config_file "etc/cron.d/syscp"
	mkdir -p "${ROOT}/etc/php/syscp-cronjob"
	chmod 0700 "${ROOT}/etc/php/syscp-cronjob"
	create_config_file "etc/php/syscp-cronjob/php.ini"

	einfo "Configuring ProFTPd ..."
	create_config_file "etc/proftpd/proftpd.conf"

	einfo "Configuring Courier-IMAP ..."
	create_config_file "etc/courier/authlib/authdaemonrc"
	create_config_file "etc/courier/authlib/authmysqlrc"
	create_config_file "etc/courier-imap/pop3d"
	create_config_file "etc/courier-imap/imapd"
	if built_with_use =`best_version 'www-apps/syscp'` sslserv ; then
		create_config_file "etc/courier-imap/pop3d-ssl"
		create_config_file "etc/courier-imap/imapd-ssl"
	fi

	einfo "Configuring Postfix ..."
	create_config_file "etc/sasl2/smtpd.conf"
	CHMOD="0644" create_config_file "etc/postfix/main.cf"
	CHOWN="root:postfix" CHMOD="0640" create_config_file "etc/postfix/mysql-virtual_alias_maps.cf"
	CHOWN="root:postfix" CHMOD="0640" create_config_file "etc/postfix/mysql-virtual_mailbox_domains.cf"
	CHOWN="root:postfix" CHMOD="0640" create_config_file "etc/postfix/mysql-virtual_mailbox_maps.cf"

	if built_with_use =`best_version 'www-apps/syscp'` bind ; then
		einfo "Configuring Bind .."
		CHMOD="0644" create_config_file "etc/bind/syscp_bind.conf"
		CHMOD="0644" create_config_file "etc/bind/default.zone"
	fi

	# Automatical service starting

	sleep 2
	srv_add_restart apache${USE_APACHE2}
	srv_add_restart vixie-cron
	if built_with_use =`best_version 'www-apps/syscp'` bind ; then
		srv_add_restart named
	fi
	srv_add_restart proftpd
	srv_add_restart courier-authlib
	srv_add_restart courier-pop3d
	srv_add_restart courier-imapd
	if built_with_use =`best_version 'www-apps/syscp'` sslserv ; then
		srv_add_restart courier-pop3d-ssl
		srv_add_restart courier-imapd-ssl
	fi
	srv_add_restart postfix

	einfo "Removing temporary work directory ..."
	rm -Rf "${ROOT}/tmp/syscp-install-by-emerge" || ewarn "Please remove the temporary install data manually by doing 'rm -Rf \"${ROOT}/tmp/syscp-install-by-emerge\"'"

	einfo "Configuration completed successfully!"
}


# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

# ie 1.2.3.4 => 1.2.3-4
MY_PV="${PV%.*}-${PV##*.}"
DESCRIPTION="cups driver for brother printer"
HOMEPAGE="http://solutions.brother.com/linux/en_us/index.html"

PRINTER_L="MFC-7420"
PRINTER=${PRINTER_L/-/}
#printer=$(echo ${PRINTER} | awk '{print tolower($1)}')
printer=$(echo ${PRINTER} | tr "[:upper:]" "[:lower:]")
url="http://solutions.brother.com/Library/sol/printer/linux/rpmfiles/"
SRC_URI="${url}lpr_debian/br${printer}lpr-${MY_PV}.i386.deb
	${url}cups_wrapper/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2 as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-text/psutils
	app-text/a2ps"
RDEPEND="${DEPEND}"
RESTRICT="mirror strip"

# @FUNCTION: get_file
# @USAGE: <input> <output> <search>
# @DESCRIPTION
# Extracts from <input> to <output> limited by <search>
extract_from_installer()
{
	sed "0,/$3/d; /$3/,/.*/d; s:\\\::g" $1 > $2
#	local pos=($(grep -n $3 $1 | sed -e 's:^\([0-9]*\).*$:\1:'))
#	cat $1 | tail -n $(($(cat $1 | wc -l)-${pos[0]})) | \
#		head -n $((${pos[1]}-${pos[0]}-1)) | sed -e "s:\\\::g" > $2
}

src_unpack()
{
	local files=( ${A} )
	unpack ${files[0]} "./data.tar.gz" ${files[1]}
	rm -f control.tar.gz data.tar.gz debian-binary

	# /usr/local/Brother isn't a nice path...
	sed -i -e "s:/usr/local/Brother:/usr/share/brother:g" $(find . -type f)

	local wrapper="${PN}-${MY_PV}/scripts/cupswrapper${PRINTER}-${PV%.*}"
	extract_from_installer ${wrapper} brlpdwrapper${PRINTER} ENDOFWFILTER
	PPDFILE="Brother-${PRINTER_L}-lpr.ppd"
	extract_form_installer ${wrapper} ${PPDFILE} ENDOFPPDFILE

	sed -i -e "s/\(SaveMode:* \)Off/\1OFF/g" \
	  -e "s/\(SaveMode:* \)On/\1ON/g" ${PPDFILE}

	gzip ${PPDFILE}
	PPDFILE="${PPDFILE}.gz"

	#The driver is missing this file.
	echo ${PRINTER} >> usr/local/Brother/inf/brPrintList
}

doecho()
{
	echo "$@"
	eval "$@"
}

src_compile()
{
	doecho $(tc-getCC) ${CFLAGS} -o brcupsconfig3 \
		${PN}-${MY_PV}/brcupsconfig3/brcupsconfig.c
	doecho $(tc-getSTRIP) --strip-unneeded -R .comment brcupsconfig3
}

src_install()
{
	dobin usr/bin/*

	exeinto /usr/lib32
	doexe usr/lib/*

	exeinto /usr/libexec/cups/filter
	doexe brlpdwrapper${PRINTER}

	insinto /usr/share/ppd/Brother
	doins ${PPDFILE}

	exeinto /usr/share/brother/cupswrapper
	doexe brcupsconfig3

	exeinto /usr/share/brother/lpd
	doexe usr/local/Brother/lpd/*

#	exeinto /usr/share/brother/inf
	insinto /usr/share/brother/inf

	cd usr/local/Brother/inf/
	doins br* paperinf
#	doexe braddprinter setupPrintcap
	diropts -m 0700 -o lp -g lp
	dodir /var/spool/lpd/${PRINTER}

}

pkg_postinst()
{
	elog "You can install the printer using the following command:"
	elog "lpadmin -p ${PRINTER} -E -v usb:/dev/usb/lp0" \
		"-P	/usr/share/ppd/Brother/${PPDFILE}"
	echo
}

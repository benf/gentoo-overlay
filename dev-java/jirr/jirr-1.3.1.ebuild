# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-utils-2

MY_P="${P/-/_}"
MY_P="${MY_P//./_}"

DESCRIPTION="Jirr is a Java binding of the Irrlicht Engine."
HOMEPAGE="http://jirr.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}_src.zip"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

COMMON_DEP=""

RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${COMMON_DEP}"

EANT_BUILD_TARGET=""
EANT_DOC_TARGET=""

S=${WORKDIR}/${PV}-src

src_compile() {
	cd "${S}"
	pwd
#	ls 
	ls *java
	ejavac -classpath ".;${PN}.jar" -source 5 -target 5 $(find . -name="*.java")

}

src_install() {
	java-pkg_dojar "${PN}.jar"
#	use doc && java-pkg_dojavadoc build/javadoc
#	use source && java-pkg_dosrc src
}


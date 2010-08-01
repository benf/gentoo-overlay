# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

#EGIT_REPO_URI="git://anongit.freedesktop.org/mesa/mesa"
EGIT_REPO_URI="git://anongit.freedesktop.org/~krh/mesa"
EGIT_BRANCH="egl-kms-6"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git"
	EXPERIMENTAL="true"
fi

inherit base autotools multilib flag-o-matic toolchain-funcs versionator ${GIT_ECLASS}

OPENGL_DIR="xorg-x11"

MY_PN="${PN/m/M}"
MY_P="${MY_PN}-${PV/_/-}"
MY_SRC_P="${MY_PN}Lib-${PV/_/-}"

FOLDER=$(get_version_component_range 1-3)
[[ ${PV/_rc*/} == ${PV} ]] || FOLDER+="/RC"

DESCRIPTION="OpenGL-like graphic library for Linux"
HOMEPAGE="http://mesa3d.sourceforge.net/"

#SRC_PATCHES="mirror://gentoo/${P}-gentoo-patches-01.tar.bz2"
if [[ $PV = 9999* ]]; then
	SRC_URI="${SRC_PATCHES}"
else
	SRC_URI="ftp://ftp.freedesktop.org/pub/mesa/${FOLDER}/${MY_SRC_P}.tar.bz2
		${SRC_PATCHES}"
fi

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"

INTEL_CARDS="i810 i915 i965 intel"
RADEON_CARDS="r100 r200 r300 r600 radeon radeonhd"
VIDEO_CARDS="${INTEL_CARDS} ${RADEON_CARDS} mach64 mga none nouveau r128 savage sis vmware tdfx via"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS}
	+classic debug +gallium llvm motif +nptl pic selinux +xcb kernel_FreeBSD
	gles1 gles2"

LIBDRM_DEPSTRING=">=x11-libs/libdrm-2.4.21"
# keep correct libdrm and dri2proto dep
# keep blocks in rdepend for binpkg
RDEPEND="
	!<x11-base/xorg-server-1.7
	!<=x11-proto/xf86driproto-2.0.3
	>=app-admin/eselect-mesa-0.0.3
	>=app-admin/eselect-opengl-1.1.1-r2
	dev-libs/expat
	x11-libs/libICE
	x11-libs/libX11[xcb?]
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXxf86vm
	x11-proto/kbproto
	motif? ( x11-libs/openmotif )
	gallium? (
		llvm? (
			dev-libs/udis86
			sys-devel/llvm
		)
	)
	${LIBDRM_DEPSTRING}[video_cards_nouveau?,video_cards_vmware?]
"
for card in ${INTEL_CARDS}; do
	RDEPEND="${RDEPEND}
		video_cards_${card}? ( ${LIBDRM_DEPSTRING}[video_cards_intel] )
	"
done

for card in ${RADEON_CARDS}; do
	RDEPEND="${RDEPEND}
		video_cards_${card}? ( ${LIBDRM_DEPSTRING}[video_cards_radeon] )
	"
done

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	x11-misc/makedepend
	>=x11-proto/dri2proto-2.2
	>=x11-proto/glproto-1.4.11
	x11-proto/inputproto
	>=x11-proto/xextproto-7.0.99.1
	x11-proto/xf86driproto
	x11-proto/xf86vidmodeproto
"

S="${WORKDIR}/${MY_P}"

# It is slow without texrels, if someone wants slow
# mesa without texrels +pic use is worth the shot
QA_EXECSTACK="usr/lib*/opengl/xorg-x11/lib/libGL.so*"
QA_WX_LOAD="usr/lib*/opengl/xorg-x11/lib/libGL.so*"

# Think about: ggi, fbcon, no-X configs

pkg_setup() {
	# gcc 4.2 has buggy ivopts
	if [[ $(gcc-version) = "4.2" ]]; then
		append-flags -fno-ivopts
	fi

	# recommended by upstream
	append-flags -ffast-math
}

src_unpack() {
	[[ $PV = 9999* ]] && git_src_unpack || base_src_unpack
}

src_prepare() {
	# apply patches
	if [[ ${PV} != 9999* && -n ${SRC_PATCHES} ]]; then
		EPATCH_FORCE="yes" \
		EPATCH_SOURCE="${WORKDIR}/patches" \
		EPATCH_SUFFIX="patch" \
		epatch
	fi
	# FreeBSD 6.* doesn't have posix_memalign().
	if [[ ${CHOST} == *-freebsd6.* ]]; then
		sed -i \
			-e "s/-DHAVE_POSIX_MEMALIGN//" \
			configure.ac || die
	fi

	# In order for mesa to complete it's build process we need to use a tool
	# that it compiles. When we cross compile this clearly does not work
	# so we require mesa to be built on the host system first. -solar
	if tc-is-cross-compiler; then
		sed -i -e "s#^GLSL_CL = .*\$#GLSL_CL = glsl-compile#g" \
			"${S}"/src/mesa/shader/slang/library/Makefile || die
	fi

	[[ $PV = 9999* ]] && git_src_prepare
	base_src_prepare

	eautoreconf
}

src_configure() {
	local myconf

	if use classic; then
	# Configurable DRI drivers
		driver_enable swrast

	# Intel code
		driver_enable video_cards_i810 i810
		driver_enable video_cards_i915 i915
		driver_enable video_cards_i965 i965
			if ! use video_cards_i810 && \
				! use video_cards_i915 && \
				! use video_cards_i965; then
			driver_enable video_cards_intel i810 i915 i965
		fi

		# Nouveau code
		driver_enable video_cards_nouveau nouveau

		# ATI code
		driver_enable video_cards_mach64 mach64
		driver_enable video_cards_mga mga
		driver_enable video_cards_r128 r128

		driver_enable video_cards_r100 radeon
		driver_enable video_cards_r200 r200
		driver_enable video_cards_r300 r300
		driver_enable video_cards_r600 r600
		if ! use video_cards_r100 && \
				! use video_cards_r200 && \
				! use video_cards_r300 && \
				! use video_cards_r600; then
			driver_enable video_cards_radeon radeon r200 r300 r600
			driver_enable video_cards_radeonhd r300 r600
		fi

		driver_enable video_cards_savage savage
		driver_enable video_cards_sis sis
		driver_enable video_cards_tdfx tdfx
		driver_enable video_cards_via unichrome
	fi

	myconf="${myconf} $(use_enable gallium)"
	if use gallium; then
		elog "You have enabled gallium infrastructure."
		elog "This infrastructure currently support these drivers:"
		elog "    Intel: works only i915 and i965 somehow."
		elog "    LLVMpipe: Software renderer."
		elog "    Nouveau: Support for nVidia NV30 and later cards."
		elog "    Radeon: Newest implementation of r300-r700 driver."
		elog "    Svga: VMWare Virtual GPU driver."
		echo
		myconf="${myconf}
			--with-state-trackers=glx,dri,egl,vega
			$(use_enable llvm gallium-llvm)
			$(use_enable video_cards_vmware gallium-svga)
			$(use_enable video_cards_nouveau gallium-nouveau)"
		if use video_cards_i915 || \
				use video_cards_intel; then
			myconf="${myconf} --enable-gallium-i915"
		else
			myconf="${myconf} --disable-gallium-i915"
		fi
		if use video_cards_i965 || \
				use video_cards_intel; then
			myconf="${myconf} --enable-gallium-i965"
		else
			myconf="${myconf} --disable-gallium-i965"
		fi
		if use video_cards_r300 || \
				use video_cards_radeon || \
				use video_cards_radeonhd; then
			myconf="${myconf} --enable-gallium-radeon"
		else
			myconf="${myconf} --disable-gallium-radeon"
		fi
		if use video_cards_r600 || \
				use video_cards_radeon || \
				use video_cards_radeonhd; then
			myconf="${myconf} --enable-gallium-r600"
		else
			myconf="${myconf} --disable-gallium-r600"
		fi
	else
		if use video_cards_nouveau || use video_cards_vmware; then
			elog "SVGA and nouveau drivers are available only via gallium interface."
			elog "Enable gallium useflag if you want to use them."
		fi
	fi

	# --with-driver=dri|xlib|osmesa || do we need osmesa?
	econf \
		--disable-option-checking \
		--with-driver=dri \
		--disable-glut \
		--without-demos \
		$(use_enable debug) \
		$(use_enable motif glw) \
		$(use_enable motif) \
		$(use_enable nptl glx-tls) \
		$(use_enable xcb) \
		$(use_enable !pic asm) \
		$(use_enable gles1) \
		$(use_enable gles2) \
		--with-egl-platforms=x11,kms \
		--with-dri-drivers=${DRI_DRIVERS} \
		${myconf}

}

src_install() {
	base_src_install

	# Save the glsl-compiler for later use
	if ! tc-is-cross-compiler; then
		dodir /usr/bin/
		cp "${S}"/src/glsl/apps/compile "${D}"/usr/bin/glsl-compile \
			|| die "failed to copy the glsl compiler."
	fi
	# Remove redundant headers
	# GLUT thing
	rm -f "${D}"/usr/include/GL/glut*.h || die "Removing glut include failed."
	# Glew includes
	rm -f "${D}"/usr/include/GL/{glew,glxew,wglew}.h \
		|| die "Removing glew includes failed."

	# Move libGL and others from /usr/lib to /usr/lib/opengl/blah/lib
	# because user can eselect desired GL provider.
	ebegin "Moving libGL and friends for dynamic switching"
		dodir /usr/$(get_libdir)/opengl/${OPENGL_DIR}/{lib,extensions,include}
		local x
		for x in "${D}"/usr/$(get_libdir)/libGL.{la,a,so*}; do
			if [ -f ${x} -o -L ${x} ]; then
				mv -f "${x}" "${D}"/usr/$(get_libdir)/opengl/${OPENGL_DIR}/lib \
					|| die "Failed to move ${x}"
			fi
		done
		for x in "${D}"/usr/include/GL/{gl.h,glx.h,glext.h,glxext.h}; do
			if [ -f ${x} -o -L ${x} ]; then
				mv -f "${x}" "${D}"/usr/$(get_libdir)/opengl/${OPENGL_DIR}/include \
					|| die "Failed to move ${x}"
			fi
		done
	eend $?

	ebegin "Moving DRI/Gallium drivers for dynamic switching"
		local gallium_drivers=( i915_dri.so i965_dri.so r300_dri.so r600_dri.so swrast_dri.so )
		dodir /usr/$(get_libdir)/mesa
		for x in ${gallium_drivers[@]}; do
			if [ -f ${S}/$(get_libdir)/gallium/${x} ]; then
				mv -f "${D}/usr/$(get_libdir)/dri/${x}" "${D}/usr/$(get_libdir)/dri/${x/_dri.so/g_dri.so}" \
					|| die "Failed to move ${x}"
				insinto "/usr/$(get_libdir)/dri/"
				if [ -f ${S}/$(get_libdir)/${x} ]; then
					insopts -m0755
					doins "${S}/$(get_libdir)/${x}" || die "failed to install ${x}"
				fi
			fi
		done
		for x in "${D}"/usr/$(get_libdir)/dri/*.so; do
			if [ -f ${x} -o -L ${x} ]; then
				mv -f "${x}" "${x/dri/mesa}" \
					|| die "Failed to move ${x}"
			fi
		done
		pushd "${D}"/usr/$(get_libdir)/dri || die "pushd failed"
		ln -s ../mesa/*.so . || die "Creating symlink failed"
	# remove symlinks to drivers known to eselect
		for x in ${gallium_drivers[@]}; do
			if [ -f ${x} -o -L ${x} ]; then
				rm "${x}" || die "Failed to remove ${x}"
			fi
		done
		popd
	eend $?
}

pkg_postinst() {
	# Switch to the xorg implementation.
	echo
	eselect opengl set --use-old ${OPENGL_DIR}
	# Select classic/gallium drivers
	eselect mesa set --auto
}

# $1 - VIDEO_CARDS flag
# other args - names of DRI drivers to enable
driver_enable() {
	case $# in
		# for enabling unconditionally
		1)
			DRI_DRIVERS+=",$1"
			;;
		*)
			if use $1; then
				shift
				for i in $@; do
					DRI_DRIVERS+=",${i}"
				done
			fi
			;;
	esac
}

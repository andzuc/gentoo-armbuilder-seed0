FROM andzuc/gentoo-armbuilder-s4

# seed0: config
ENV DOCKER_FEATURES="-sandbox -usersandbox buildpkg noman noinfo nodoc"
ENV DOCKER_PROFILE=default/linux/arm/17.0/armv6j
RUN echo "ACCEPT_CHOSTS='${DOCKER_TARGET}'" >>/etc/portage/make.conf \
    && sed -i \
	   's|PKGDIR=".*"|PKGDIR="'"/builder/packages"'"|' \
	   "/etc/portage/make.conf" \
    && sed -i \
	   's|PKGDIR=.*|PKGDIR="'"/builder/packages"'"|' \
	   "/usr/${DOCKER_TARGET}/etc/portage/make.conf" \
    && sed -i \
	   's!ACCEPT_KEYWORDS="\(.*\)"!ACCEPT_KEYWORDS="'"\${ARCH}"'"!' \
	   "/usr/${DOCKER_TARGET}/etc/portage/make.conf" \
    && sed -i \
	   's!FEATURES=".*"!FEATURES="'"${DOCKER_FEATURES}"'"!' \
	   "/usr/${DOCKER_TARGET}/etc/portage/make.conf" \
    && sed -i \
	   's!USE="\(.*\)"!USE="'"\1"'"!' \
	   "/usr/${DOCKER_TARGET}/etc/portage/make.conf" \
    && cat "/usr/${DOCKER_TARGET}/etc/portage/make.conf" \
    && ARCH=`cat "/usr/${DOCKER_TARGET}/etc/portage/make.conf"|grep "ARCH="|sed "s/ARCH=\(.*\)/\1/"` \
	   PORTAGE_CONFIGROOT="/usr/${DOCKER_TARGET}/" \
	   eselect profile set "${DOCKER_PROFILE}" \
    && ARCH=`cat "/usr/${DOCKER_TARGET}/etc/portage/make.conf"|grep "ARCH="|sed "s/ARCH=\(.*\)/\1/"` \
	   PORTAGE_CONFIGROOT="/usr/${DOCKER_TARGET}/" \
	   eselect profile show \
    && mkdir -p /builder/seed \
    && mkdir -p /builder/packages

# seed0: emerge base system 
# https://wiki.gentoo.org/wiki/Porting
ENV DOCKER_PKGLIST_SEED0=" \
sys-devel/binutils \
sys-kernel/linux-headers \
sys-libs/glibc \
sys-devel/gcc \
dev-lang/python \
net-misc/rsync \
net-misc/wget \
app-arch/tar \
app-arch/gzip \
app-arch/bzip2 \
sys-apps/coreutils \
app-shells/bash"
RUN time "${DOCKER_TARGET}-emerge" -v --color n ${DOCKER_PKGLIST_SEED0} \
    && emerge --root /builder/seed -v --color n --usepkgonly ${DOCKER_PKGLIST_SEED0}

RUN time mkdir -p /builder/seed/etc/portage \
    && echo 'CHOST="'${DOCKER_TARGET}'"' >>/builder/seed/etc/portage/make.conf \
    && cat /usr/${DOCKER_TARGET}/etc/portage/make.conf|grep "CFLAGS=" >>/builder/seed/etc/portage/make.conf \
    && cat /usr/${DOCKER_TARGET}/etc/portage/make.conf|grep "CXXFLAGS=" >>/builder/seed/etc/portage/make.conf \
    && cat /builder/seed/etc/portage/make.conf \
    && ln -s "../../usr/portage/profiles/${DOCKER_PROFILE}" /builder/seed/etc/portage/etc/portage/make.profile

# seed0: emerge stage1 gcc (C only)
# RUN time USE="nls nptl pch pie ssp -cilk -cxx -debug -doc -fortran -go -graphite -hardened -jit -libssp -mpx -multilib -objc -objc++ -objc-gc -openmp -pgo -regression-test -sanitize -vanilla -vtv" \
#     "${DOCKER_TARGET}-emerge" -v --color n sys-devel/gcc \
#     && emerge --root /builder/seed -v --color n --usepkgonly sys-devel/gcc

# ENV DOCKER_CFLAGS="-Ofast -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s -fomit-frame-pointer -pipe -fno-stack-protector -U_FORTIFY_SOURCE"
# RUN sed -i \
#     's/CFLAGS=".*"/CFLAGS="'"${DOCKER_CFLAGS}"'"/' \
#     "/usr/${DOCKER_TARGET}/etc/portage/make.conf"

#COPY builder /builder
#RUN time emerge -v dev-util/catalyst
#RUN catalyst -s "$(date +%Y.%m)"

# build @sysnodev
#RUN "${DOCKER_TARGET}-emerge" --info
#RUN time "${DOCKER_TARGET}-emerge" -ev --color n --keep-going @system --exclude "sys-devel/gcc"

FROM andzuc/gentoo-armbuilder-s4

# seed0: config
ENV DOCKER_ACCEPT_KEYWORDS="arm"
ENV DOCKER_FEATURES="-sandbox -usersandbox buildpkg noman noinfo nodoc"
ENV DOCKER_PROFILE=default/linux/arm/17.0/armv6j
RUN echo "ACCEPT_CHOSTS='${DOCKER_TARGET}'" >>/etc/portage/make.conf \
    && sed -i \
    's|PKGDIR=".*"|PKGDIR="'"/usr/${DOCKER_TARGET}/packages"'"|' \
    "/etc/portage/make.conf" \
    && sed -i \
    's/ACCEPT_KEYWORDS=".*"/ACCEPT_KEYWORDS="'"${DOCKER_ACCEPT_KEYWORDS}"'"/' \
    "/usr/${DOCKER_TARGET}/etc/portage/make.conf" \
    && sed -i \
    's/FEATURES=".*"/FEATURES="'"${DOCKER_FEATURES}"'"/' \
    "/usr/${DOCKER_TARGET}/etc/portage/make.conf" \
    && cat "/usr/${DOCKER_TARGET}/etc/portage/make.conf" \
    && ARCH=arm PORTAGE_CONFIGROOT="/usr/${DOCKER_TARGET}/" eselect profile set "${DOCKER_PROFILE}" \
    && mkdir -p /builder/seed

# seed0: emerge base system 
ENV DOCKER_PKGLIST_SEED0=" \
sys-devel/binutils \
sys-kernel/linux-headers \
sys-libs/glibc \
sys-apps/coreutils \
app-shells/bash"
RUN time "${DOCKER_TARGET}-emerge" -v --color n ${DOCKER_PKGLIST_SEED0} \
    && emerge --root /builder/seed -v --color n --usepkgonly ${DOCKER_PKGLIST_SEED0}

# seed0: emerge stage1 gcc (C only)
RUN time USE="nls nptl pch pie ssp -cilk -cxx -debug -doc -fortran -go -graphite -hardened -jit -libssp -mpx -multilib -objc -objc++ -objc-gc -openmp -pgo -regression-test -sanitize -vanilla -vtv" \
    "${DOCKER_TARGET}-emerge" -v --color n sys-devel/gcc \
    && emerge --root /builder/seed -v --color n --usepkgonly sys-devel/gcc

# ENV DOCKER_CFLAGS="-Ofast -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s -fomit-frame-pointer -pipe -fno-stack-protector -U_FORTIFY_SOURCE"
# RUN sed -i \
#     's/CFLAGS=".*"/CFLAGS="'"${DOCKER_CFLAGS}"'"/' \
#     "/usr/${DOCKER_TARGET}/etc/portage/make.conf"

# setup QEMU
#RUN cp /usr/bin/qemu-arm "/usr/${DOCKER_TARGET}/usr/bin/qemu-arm"
#RUN time emerge -v dev-util/catalyst

#RUN catalyst -s "$(date +%Y.%m)"
#COPY builder /builder

# build @sysnodev
#RUN "${DOCKER_TARGET}-emerge" --info
#RUN time "${DOCKER_TARGET}-emerge" -ev --color n --keep-going @system --exclude "sys-devel/gcc"

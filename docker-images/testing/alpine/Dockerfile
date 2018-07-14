FROM alpine:3.7 as base

WORKDIR /tmp/workdir

RUN \
    apk add --no-cache --update libgcc libstdc++ ca-certificates libcrypto1.0 libssl1.0 libgomp expat freetype fontconfig fribidi 

FROM base AS build

ARG PREFIX="/usr/local"
ARG PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"
ARG LD_LIBRARY_PATH="$PREFIX/lib"
ARG MAKEFLAGS='-j2'

RUN \
    apk add --no-cache --update \
        autoconf \
        automake \
        binutils \
        bzip2 \
        cmake \
        curl \
        coreutils \
        diffutils \
        expat-dev \
        file \
        fontconfig-dev \
        freetype-dev \
        fribidi-dev \
        g++ \
        gcc \
        gnupg \
        gperf \
        libtool \
        make \
        nasm \
        openssl-dev \
        python \
        tar \
        yasm \
        zlib-dev


ARG OGG_SHA256SUM=c2e8a485110b97550f453226ec644ebac6cb29d1caef2902c007edab4308d985
ARG OGG_VERSION=1.3.3
RUN  \
dir=/tmp/ogg && \
mkdir -p ${dir} && \
cd ${dir} && \
curl -sLO http://downloads.xiph.org/releases/ogg/libogg-${OGG_VERSION}.tar.gz ; \
echo "${OGG_SHA256SUM}  libogg-${OGG_VERSION}.tar.gz" ; \
echo "${OGG_SHA256SUM}  libogg-${OGG_VERSION}.tar.gz" | sha256sum --check ; \
tar -zx --strip-components=1 -f libogg-${OGG_VERSION}.tar.gz ; \
./configure --prefix="${PREFIX}" --enable-shared ; \
make ; \
make install && \
rm -rf ${dir} 



ARG OPENCOREAMR_SHA1SUM=bef4d1e3a8a155b47569b6691a223843b33e279e
ARG OPENCOREAMR_VERSION=0.1.5 
RUN  \
dir=/tmp/opencore-amr && \
mkdir -p ${dir} && \
cd ${dir} && \
curl -sLO https://superb-sea2.dl.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-${OPENCOREAMR_VERSION}.tar.gz ; \
echo "${OPENCOREAMR_SHA1SUM}  opencore-amr-${OPENCOREAMR_VERSION}.tar.gz" | \
sha1sum --check ; \
tar -zx --strip-components=1 -f opencore-amr-${OPENCOREAMR_VERSION}.tar.gz ; \
./configure --prefix="${PREFIX}" --enable-shared ; \
make ; \
make install && \
rm -rf ${dir} 



ARG OPUS_SHA256SUM=cfafd339ccd9c5ef8d6ab15d7e1a412c054bf4cb4ecbbbcc78c12ef2def70732
ARG OPUS_VERSION=1.2.1
RUN  \
dir=/tmp/opus && \
mkdir -p ${dir} && \
cd ${dir} && \
curl -sLO https://archive.mozilla.org/pub/opus/opus-${OPUS_VERSION}.tar.gz ; \
echo "${OPUS_SHA256SUM}  opus-${OPUS_VERSION}.tar.gz" | sha256sum --check  ; \
tar -zx --strip-components=1 -f opus-${OPUS_VERSION}.tar.gz ; \
autoreconf -fiv ; \
./configure --prefix="${PREFIX}" --enable-shared ; \
make ; \
make install && \
rm -rf ${dir} 



ARG X264_VERSION=20180210-2245-stable
RUN set -e ;\
dir=/tmp/x264 ;\
mkdir -p ${dir} ;\
cd ${dir} ;\
if echo ${X264_VERSION} | grep -q '^last'; then \
    curl -sL https://download.videolan.org/pub/videolan/x264/snapshots/${X264_VERSION}_x264.tar.bz2 | tar -jx --strip-components=1 ; \
else \
    curl -sL https://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-${X264_VERSION}.tar.bz2 | tar -jx --strip-components=1 ; \
fi ; \
    ./configure --prefix="${PREFIX}" --enable-shared --enable-pic ; \
make ; \
make install && \
rm -rf ${dir}



ARG X265_MD5SUM=b68dcd4e8a495e53e53034a11fec5eb9
ARG X265_VERSION=2.8
RUN  \
dir=/tmp/x265 && \
mkdir -p ${dir} && \
curl -sLO https://download.videolan.org/pub/videolan/x265/x265_${X265_VERSION}.tar.gz ; \
echo "${X265_MD5SUM}  x265_${X265_VERSION}.tar.gz" | md5sum --check ; \
tar -zx --strip-component=1 -f x265_${X265_VERSION}.tar.gz ; \
cd build/linux ; \
sed -i "/-DEXTRA_LIB/ s/$/ -DCMAKE_INSTALL_PREFIX=\${PREFIX}/" multilib.sh ; \
sed -i "/^cmake/ s/$/ -DENABLE_CLI=ON/" multilib.sh ; \
./multilib.sh ; \
make -C 8bit install && \
rm -rf ${dir}



ARG OPENJPEG_VERSION=2.3.0
RUN  \
dir=/tmp/openjpeg && \
mkdir -p ${dir} && \
cd ${dir} && \
curl -sL https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG_VERSION}.tar.gz | \
tar -zx --strip-components=1 ; \
cmake -DBUILD_THIRDPARTY:BOOL=ON -DCMAKE_INSTALL_PREFIX="${PREFIX}" . ; \
make ; \
make install && \
rm -rf ${dir}



ARG FDKAAC_VERSION=0.1.6
RUN  \
dir=/tmp/fdkaac && \
mkdir -p ${dir} && \
cd ${dir} && \
curl -sL https://github.com/mstorsjo/fdk-aac/archive/v${FDKAAC_VERSION}.tar.gz | \
tar -zx --strip-components=1 ; \
autoreconf -fiv ; \
./configure --prefix="${PREFIX}" --enable-shared --datadir="${PWD}" ; \
make ; \
make install && \
rm -rf ${dir}


	
ARG LAME_VERSION=3.100
RUN  \
dir=/tmp/lame && \
mkdir -p ${dir} && \
cd ${dir} && \
curl -sL https://cfhcable.dl.sourceforge.net/project/lame/lame/$(echo ${LAME_VERSION} | sed -e 's/[^0-9]*\([0-9]*\)[.]\([0-9]*\)[.]\([0-9]*\)\([0-9A-Za-z-]*\)/\1.\2/')/lame-${LAME_VERSION}.tar.gz | \
tar -zx --strip-components=1 ; \
./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" --enable-shared --enable-nasm --enable-pic --enable-frontend ; \
make ; \
make install && \
rm -rf ${dir}



ARG ASS_SHA256SUM=
ARG ASS_VERSION=0.14.0
RUN  \
dir=/tmp/ass && \
mkdir -p ${dir} && \
cd ${dir} && \
curl -sLO https://github.com/libass/libass/archive/${ASS_VERSION}.tar.gz ; \
tar -zx --strip-components=1 -f ${ASS_VERSION}.tar.gz ; \
./autogen.sh ; \
./configure -prefix="${PREFIX}" --disable-static --enable-shared ; \
make ; \
make install && \
rm -rf ${dir}


    
ARG THEORA_SHA256SUM=40952956c47811928d1e7922cda3bc1f427eb75680c3c37249c91e949054916b
ARG THEORA_VERSION=1.1.1
RUN  \
dir=/tmp/theora && \
mkdir -p ${dir} && \
cd ${dir} && \
curl -sLO http://downloads.xiph.org/releases/theora/libtheora-${THEORA_VERSION}.tar.gz ; \
echo "${THEORA_SHA256SUM}  libtheora-${THEORA_VERSION}.tar.gz"| sha256sum --check ; \
tar -zx --strip-components=1 -f libtheora-${THEORA_VERSION}.tar.gz ; \
sed -i 's/png_\(sizeof\)/\1/g' examples/png2theora.c ; \
./configure --prefix="${PREFIX}" --with-ogg="${PREFIX}" --enable-shared ; \
make ; \
make install && \
rm -rf ${dir}


    
ARG VORBIS_SHA256SUM=6ed40e0241089a42c48604dc00e362beee00036af2d8b3f46338031c9e0351cb
ARG VORBIS_VERSION=1.3.6
RUN  \
dir=/tmp/vorbis && \
mkdir -p ${dir} && \
cd ${dir} && \
curl -sLO http://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS_VERSION}.tar.gz ; \
echo "${VORBIS_SHA256SUM}  libvorbis-${VORBIS_VERSION}.tar.gz" | sha256sum --check  ; \
tar -zx --strip-components=1 -f libvorbis-${VORBIS_VERSION}.tar.gz ; \
./configure --prefix="${PREFIX}" --with-ogg="${PREFIX}" --enable-shared ; \
make ; \
make install && \
rm -rf ${dir}


	
ARG VPX_VERSION=1.7.0
RUN  \
dir=/tmp/vpx && \
mkdir -p ${dir} && \
cd ${dir} && \
curl -sL https://codeload.github.com/webmproject/libvpx/tar.gz/v${VPX_VERSION} | \
tar -zx --strip-components=1 ; \
./configure --prefix="${PREFIX}" --enable-vp8 --enable-vp9 --enable-pic --enable-shared \
--disable-debug --disable-examples --disable-docs --enable-install-bins ; \
make ; \
make install && \
rm -rf ${dir}


    
ARG XVID_SHA256SUM=
ARG XVID_VERSION=1.3.5
RUN  \
dir=/tmp/xvid && \
mkdir -p ${dir} && \
cd ${dir} && \
curl -sLO http://downloads.xvid.org/downloads/xvidcore-${XVID_VERSION}.tar.gz ; \
tar -zx -f xvidcore-${XVID_VERSION}.tar.gz ; \
cd xvidcore/build/generic ; \
./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" --datadir="${PWD}" --enable-shared ; \
make ; \
make install && \
rm -rf ${dir}



ARG VIDSTAB_SHA256SUM=14d2a053e56edad4f397be0cb3ef8eb1ec3150404ce99a426c4eb641861dc0bb
ARG VIDSTAB_VERSION=1.1.0
RUN  \
dir=/tmp/vidstab && \
mkdir -p ${dir} && \
cd ${dir} && \
curl -sLO https://github.com/georgmartius/vid.stab/archive/v${VIDSTAB_VERSION}.tar.gz ; \
echo "${VIDSTAB_SHA256SUM}  v${VIDSTAB_VERSION}.tar.gz" | sha256sum --check  ; \
tar -zx --strip-components=1 -f v${VIDSTAB_VERSION}.tar.gz ; \
cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" . ; \
make ; \
make install && \
rm -rf ${dir}



ARG KVAZAAR_VERSION=1.2.0
RUN  \
dir=/tmp/kvazaar && \
mkdir -p ${dir} && \
cd ${dir} && \
curl -sLO https://github.com/ultravideo/kvazaar/archive/v${KVAZAAR_VERSION}.tar.gz ; \
tar -zx --strip-components=1 -f v${KVAZAAR_VERSION}.tar.gz ; \
if [ $KVAZAAR_VERSION != '0.6.1' ]; then \
./autogen.sh ; \
./configure -prefix="${PREFIX}" --disable-static --enable-shared ; \
else \
cd src ; \
fi ;\
make ; \
make PREFIX=${PREFIX} install && \
rm -rf ${dir}



ARG AOM_VERSION=v1.0.0
RUN  \
dir=/tmp/aom && \
mkdir -p ${dir} && \
cd ${dir} && \
curl -sLO https://aomedia.googlesource.com/aom/+archive/${AOM_VERSION}.tar.gz ; \
tar -zx -f ${AOM_VERSION}.tar.gz ; \
rm -rf CMakeCache.txt CMakeFiles ; \
mkdir -p ../aom_build ; \
cd ../aom_build ; \ 
cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DBUILD_SHARED_LIBS=1 ../aom; \
make ; \
make install && \
rm -rf ${dir}


ENV FFMPEG_VERSION=4.0 \
	FFMPEG_GPG=FCF986EA15E6E293A5644F10B4322F04D67658D8 

RUN \
dir=/tmp/ffmpeg && \
mkdir -p ${dir} && \
cd ${dir} && \
curl -sLO https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 && \
curl -sLO https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2.asc && \
if grep -vi '<DOCTYPE'; then \
gpg --batch --keyserver ipv4.pool.sks-keyservers.net --recv-keys ${FFMPEG_GPG} ; \
gpg --batch --verify ffmpeg-4.0.tar.bz2.asc ffmpeg-${FFMPEG_VERSION}.tar.bz2 ; \
fi && \
tar -x --strip-components=1 -f ffmpeg-${FFMPEG_VERSION}.tar.bz2 && \
./configure \
--disable-debug \
--disable-doc \
--disable-ffplay \
--enable-shared \
--enable-avresample \
--enable-gpl \
--enable-nonfree \
--enable-postproc \
--enable-small \
--enable-version3 \
--enable-libfreetype \
--enable-libopencore-amrnb --enable-libopencore-amrwb  \
--enable-libopus  \
--enable-libx264  \
--enable-libx265  \
--enable-libass  \
--enable-libvidstab  \
--enable-libmp3lame  \
--enable-libopenjpeg  \
--enable-libtheora  \
--enable-libvorbis  \
--enable-libvpx  \
--enable-libxvid  \
--enable-libfdk_aac  \
--enable-libkvazaar  \
--enable-libaom --extra-libs=-lpthread  \
--extra-cflags="-I${PREFIX}/include" \
--extra-ldflags="-L${PREFIX}/lib" \
--extra-libs=-ldl \
--prefix="${PREFIX}" && \
make && \
make install && \
make distclean && \
hash -r && \
cd tools && \
make qt-faststart && \
cp qt-faststart ${PREFIX}/bin

RUN set -e ;\
LD_LIBRARY_PATH=/usr/local/lib ffmpeg -buildconf

FROM        base

ONBUILD ARG PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"
ONBUILD ARG PREFIX="/usr/local"
ENV         LD_LIBRARY_PATH=/usr/local/lib

COPY --from=build /usr/local/ /usr/local/


TERMUX_PKG_HOMEPAGE=https://boost.org
TERMUX_PKG_DESCRIPTION="Free peer-reviewed portable C++ source libraries"
TERMUX_PKG_VERSION=1.68.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=7f6130bc3cf65f56a618888ce9d5ea704fa10b462be126ad053e80e553d6d8b7
TERMUX_PKG_SRCURL=https://dl.bintray.com/boostorg/release/$TERMUX_PKG_VERSION/source/boost_${TERMUX_PKG_VERSION//./_}.tar.bz2
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="libbz2, liblzma"
TERMUX_PKG_BUILD_DEPENDS="python, python2"
TERMUX_PKG_BREAKS="libboost-python (<= 1.65.1-2)"
TERMUX_PKG_REPLACES="libboost-python (<= 1.65.1-2)"

termux_step_make_install() {
	CXXFLAGS+=" -std=c++14"

	rm $TERMUX_PREFIX/lib/libboost* -f
	rm $TERMUX_PREFIX/include/boost -rf

	./bootstrap.sh
	echo "using clang : $TERMUX_ARCH : $CXX : <linkflags>-L/data/data/com.termux/files/usr/lib ; " >> project-config.jam
	echo "using python : 3.7 : $TERMUX_PREFIX/bin/python3 : $TERMUX_PREFIX/include/python3.7m : $TERMUX_PREFIX/lib ;" >> project-config.jam

	if [ "$TERMUX_ARCH" = arm ] || [ "$TERMUX_ARCH" = aarch64 ]; then
		BOOSTARCH=arm
		BOOSTABI=aapcs
	elif [ "$TERMUX_ARCH" = i686 ] || [ "$TERMUX_ARCH" = x86_64 ]; then
		BOOSTARCH=x86
		BOOSTABI=sysv
	fi

	if [ "$TERMUX_ARCH" = x86_64 ] || [ "$TERMUX_ARCH" = aarch64 ]; then
		BOOSTAM=64
	elif [ "$TERMUX_ARCH" = i686 ] || [ "$TERMUX_ARCH" = arm ]; then
		BOOSTAM=32
	fi

	./b2 target-os=android -j${TERMUX_MAKE_PROCESSES} \
		include=/data/data/com.termux/files/usr/include \
		toolset=clang-$TERMUX_ARCH \
		--prefix="$TERMUX_PREFIX"  \
		-q \
		--without-stacktrace \
		--without-log \
		--disable-icu \
		cxxflags="$CXXFLAGS" \
		architecture="$BOOSTARCH" \
		abi="$BOOSTABI" \
		address-model="$BOOSTAM" \
		boost.locale.icu=off \
		binary-format=elf \
		link=shared \
		threading=multi \
		install

	./bootstrap.sh --with-libraries=python
	echo "using clang : $TERMUX_ARCH : $CXX : <linkflags>-L/data/data/com.termux/files/usr/lib ; " >> project-config.jam
	echo "using python : 2.7 : $TERMUX_PREFIX/bin/python2 : $TERMUX_PREFIX/include/python2.7 : $TERMUX_PREFIX/lib ;" >> project-config.jam

	./b2 target-os=android -j${TERMUX_MAKE_PROCESSES} \
		include=/data/data/com.termux/files/usr/include \
		toolset=clang-$TERMUX_ARCH \
		--stagedir="$TERMUX_PREFIX"  \
		-q \
		-a \
		--disable-icu \
		cxxflags="$CXXFLAGS" \
		link=shared \
		threading=multi \
		boost.locale.icu=off \
		stage
}

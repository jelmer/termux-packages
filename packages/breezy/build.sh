TERMUX_PKG_HOMEPAGE=https://www.breezy-vcs.org/
TERMUX_PKG_DESCRIPTION="easy to use distributed version control system"
TERMUX_PKG_VERSION=3.0a2
TERMUX_PKG_SRCURL=https://launchpad.net/brz/3.0/${TERMUX_PKG_VERSION}/+download/breezy-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c7805e6fd61f3046ca5b31311bc31e647e5a40b11ded85b901488d439fa9f434
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make() {
	echo Skipping make step...
}

termux_step_make_install() {
        python3.7 setup.py install --prefix=$TERMUX_PREFIX --force
}

termux_step_post_massage() {
	find . -path '*/__pycache__*' -delete
}

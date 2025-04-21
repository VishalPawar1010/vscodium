export OS_NAME=linux
export VSCODE_ARCH=x64
export SHOULD_BUILD=yes
export SHOULD_BUILD_DEB=yes
export SHOULD_BUILD_APPIMAGE=yes
source $HOME/.cargo/env
./dev/build.sh -p
#!/bin/bash

./InstallDeps.sh

set -e
set -x

#load dep exports
#need to switch to game dir for Dockerfile weirdness
original_dir=$PWD
cd "$1"
. dependencies.sh
cd "$original_dir"

# update rust-g
if [ ! -d "rust-g" ]; then
	echo "Cloning rust-g..."
	git clone https://github.com/Aurorastation/rust-g
	cd rust-g
	~/.cargo/bin/rustup target add i686-unknown-linux-gnu
else
	echo "Fetching rust-g..."
	cd rust-g
	git fetch
	~/.cargo/bin/rustup target add i686-unknown-linux-gnu
fi

echo "Deploying rust-g..."
git checkout "$RUST_G_VERSION"
env PKG_CONFIG_ALLOW_CROSS=1 ~/.cargo/bin/cargo build --ignore-rust-version --release --target=i686-unknown-linux-gnu
mv target/i686-unknown-linux-gnu/release/librust_g.so "$1/librust_g.so"
cd ..

if test -d $1/rust/bapi; then
	echo "Deploying BAPI..."
	cd $1/rust/bapi
	env PKG_CONFIG_ALLOW_CROSS=1 ~/.cargo/bin/cargo build --release --target=i686-unknown-linux-gnu
	mv target/i686-unknown-linux-gnu/release/libbapi.so "$1/libbapi.so"
	cd ..
	cd ..
fi

# compile tgui
echo "Compiling tgui..."
cd "$1"
env TG_BOOTSTRAP_CACHE="$original_dir" TG_BOOTSTRAP_NODE_LINUX=1 CBT_BUILD_MODE="TGS" tools/bootstrap/node tools/build/build.js

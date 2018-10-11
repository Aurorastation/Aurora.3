#!/usr/bin/env bash

$test_rust=$(ls $HOME/rust_g-$RUST_G_VERSION | grep "rust_g")
if [[$test_rust != ""]]; then
    echo "rust_g already cached."
    exit 0
fi

set -e

curl https://sh.rustup.rs -sSf | sh -s -- -y --default-host i686-unknown-linux-gnu

source ~/.profile
git clone --branch $RUST_G_VERSION https://github.com/tgstation/rust-g

cd rust-g
cargo build --release

mkdir -p ~/.byond/bin
cp $PWD/target/release/librust_g.so $HOME/rust_g-$RUST_G_VERSION/rust_g

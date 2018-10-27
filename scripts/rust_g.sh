#!/usr/bin/env bash

if [ -f $HOME/rust_g-$RUST_G_VERSION/rust_g ]; then
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

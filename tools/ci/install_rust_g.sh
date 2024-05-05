#!/usr/bin/env bash
set -euo pipefail

source dependencies.sh

echo "Downloading rust-g"
mkdir -p ~/.byond/bin
wget -nv -O ~/.byond/bin/librust_g.so "https://github.com/Aurorastation/rust-g/releases/download/${RUST_G_VERSION}/librust_g.so"
chmod +x ~/.byond/bin/librust_g.so
ldd ~/.byond/bin/librust_g.so

echo "Compiling bapi"
cd ./rust/bapi
rustup target add i686-unknown-linux-gnu
env PKG_CONFIG_ALLOW_CROSS=1 ~/.cargo/bin/cargo build --release --target=i686-unknown-linux-gnu
mv target/i686-unknown-linux-gnu/release/libbapi.so ../../libbapi.so
cd ..
cd ..

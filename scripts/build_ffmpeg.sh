#!/usr/bin/env bash
set -euo pipefail

#v1

TARGET="${1:-}"
if [[ "$TARGET" == "macos" ]]; then
    TARGET="macos-aarch64"
fi

if [[ "$TARGET" != "linux" && "$TARGET" != "windows" && "$TARGET" != "macos-aarch64" && "$TARGET" != "macos-x64" ]]; then
    echo "Usage: $0 <linux|windows|macos-aarch64|macos-x64>"
    exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FFMPEG_SRC="$ROOT_DIR/deps/ffmpeg_src"
BUILD_DIR="$ROOT_DIR/deps/build_ffmpeg_$TARGET"
INSTALL_DIR="$ROOT_DIR/deps/ffmpeg-$TARGET"

# 1. Shallow clone latest master if not present
if [ ! -d "$FFMPEG_SRC" ]; then
    echo "Cloning FFmpeg (depth 1)..."
    git clone --depth 1 https://github.com/FFmpeg/FFmpeg.git "$FFMPEG_SRC"
fi

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# 2. Audio-only minimal configure flags
COMMON_FLAGS=(
    --prefix="$INSTALL_DIR"
    --enable-static
    --disable-shared
    --disable-all
    --disable-programs
    --disable-doc
    --disable-avdevice
    --disable-swscale
    --disable-avfilter
    --disable-everything
    --disable-network
    --disable-autodetect
    --disable-debug
    --disable-x86asm
    --disable-zlib
    --disable-bzlib
    --disable-lzma
    --disable-iconv
    --enable-avformat
    --enable-avcodec
    --enable-avutil
    --enable-swresample
    --enable-protocol=file
    --enable-small
    --enable-decoder=aac,ac3,flac,mp3,vorbis,opus,alac,pcm_s16le,pcm_s24le,pcm_s32le,pcm_f32le,wmav1,wmav2
    --enable-demuxer=aac,flac,mp3,ogg,mov,matroska,wav,asf
    --enable-parser=aac,ac3,flac,mpegaudio,vorbis,opus,dirac
)

# 3. Platform toolchain configuration using Clang
if [ "$TARGET" = "linux" ]; then
    "$FFMPEG_SRC/configure" \
        "${COMMON_FLAGS[@]}" \
        --cc=clang \
        --cxx=clang++ \
        --ar=llvm-ar \
        --nm=llvm-nm \
        --ranlib=llvm-ranlib
elif [ "$TARGET" = "windows" ]; then
    MSVC_SDK="${HOME}/.cache/c3/msvc_sdk"
    if [ ! -d "$MSVC_SDK" ]; then
        echo "Error: MSVC SDK not found at $MSVC_SDK"
        exit 1
    fi

    TARGET_CFLAGS="--target=x86_64-pc-windows-msvc -fno-pie -idirafter $MSVC_SDK/include/crt -idirafter $MSVC_SDK/include/x64/ucrt -idirafter $MSVC_SDK/include/x64/shared -idirafter $MSVC_SDK/include/x64/um"
    TARGET_LDFLAGS="--target=x86_64-pc-windows-msvc -fuse-ld=lld -L$MSVC_SDK/x64"

    "$FFMPEG_SRC/configure" \
        "${COMMON_FLAGS[@]}" \
        --enable-cross-compile \
        --target-os=win64 \
        --arch=x86_64 \
        --cc=clang \
        --cxx=clang++ \
        --ar=llvm-ar \
        --nm=llvm-nm \
        --ranlib=llvm-ranlib \
        --extra-cflags="$TARGET_CFLAGS" \
        --extra-ldflags="$TARGET_LDFLAGS"
elif [[ "$TARGET" =~ ^macos ]]; then
    MACOS_SDK="${HOME}/.cache/c3/MacOSX.sdk"
    if [ ! -d "$MACOS_SDK" ]; then
        echo "Error: MacOS SDK not found at $MACOS_SDK"
        exit 1
    fi

    DEPLOY_TARGET="${MACOSX_DEPLOYMENT_TARGET:-11.0}"
    if [[ "$TARGET" == "macos-x64" ]]; then
        ARCH="x86_64"
        CLANG_TARGET="x86_64-apple-macos${DEPLOY_TARGET}"
    else
        ARCH="aarch64"
        CLANG_TARGET="arm64-apple-macos${DEPLOY_TARGET}"
    fi

    "$FFMPEG_SRC/configure" \
        "${COMMON_FLAGS[@]}" \
        --enable-cross-compile \
        --target-os=darwin \
        --arch="$ARCH" \
        --cc=clang \
        --cxx=clang++ \
        --ar=llvm-ar \
        --nm=llvm-nm \
        --ranlib=llvm-ranlib \
        --sysroot="$MACOS_SDK" \
        --extra-cflags="--target=$CLANG_TARGET" \
        --extra-ldflags="--target=$CLANG_TARGET -fuse-ld=lld"
fi

# 4. Compile and install
make -j"$(nproc)"
make install

# Produce .lib copies for MSVC linker compatibility
if [ "$TARGET" = "windows" ]; then
    for lib in "$INSTALL_DIR/lib"/lib*.a; do
        [ -f "$lib" ] || continue
        name="$(basename "$lib")"
        name="${name#lib}"
        name="${name%.a}.lib"
        cp "$lib" "$INSTALL_DIR/lib/$name"
    done
fi

echo "FFmpeg $TARGET static build completed at: $INSTALL_DIR"
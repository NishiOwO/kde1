# KDE1
I patched them so they work on modern platforms. \
Simply run `./build.sh --prefix=/usr/kde1` to build.

## Notes for FreeBSD
1. You should create `/usr/local/libdata/ldconfig/kde1` with `/usr/kde1/lib`, and restart ldconfig
2. You need to load `pty` module to get konsole working

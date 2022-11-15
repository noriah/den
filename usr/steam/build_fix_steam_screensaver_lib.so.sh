gcc -shared -fPIC -ldl -m32 -o fix_steam_screensaver_lib.so fix_steam_screensaver.c
gcc -shared -fPIC -ldl -m64 -o fix_steam_screensaver_lib64.so fix_steam_screensaver.c

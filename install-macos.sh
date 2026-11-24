#!/bin/sh
# Build OpenBoardView DualSide and install it to /Applications.
set -e
cd "$(dirname "$0")"
[ -x .venv/bin/python3 ] || { python3 -m venv .venv && .venv/bin/pip install -q jinja2; }
./build.sh -DPython_EXECUTABLE="$PWD/.venv/bin/python3" || true   # DMG packaging may fail; the .app is what matters
APP="/Applications/OpenBoardView.app"
rm -rf "$APP" && cp -R release_build/src/openboardview/openboardview.app "$APP"
# Make the binary use the bundled SDL2 instead of Homebrew's copy.
SDL2_REF=$(otool -L "$APP/Contents/MacOS/openboardview" | awk '/libSDL2-2.0.0.dylib/{print $1}')
[ "$SDL2_REF" = "@executable_path/../Frameworks/libSDL2-2.0.0.dylib" ] || \
	install_name_tool -change "$SDL2_REF" @executable_path/../Frameworks/libSDL2-2.0.0.dylib "$APP/Contents/MacOS/openboardview"
# Homebrew's SDL2 is sdl2-compat, which loads SDL3 at runtime: bundle it.
if [ -f "$(brew --prefix)/lib/libSDL3.0.dylib" ]; then
	cp -L "$(brew --prefix)/lib/libSDL3.0.dylib" "$APP/Contents/Frameworks/libSDL3.dylib"
	chmod u+w "$APP/Contents/Frameworks/libSDL3.dylib"
	install_name_tool -id @loader_path/libSDL3.dylib "$APP/Contents/Frameworks/libSDL3.dylib"
fi
/usr/libexec/PlistBuddy -c "Set :CFBundleName OpenBoardView DualSide" "$APP/Contents/Info.plist"
codesign --force --deep -s - "$APP"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP"
echo "Installed $APP"

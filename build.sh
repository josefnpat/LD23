#!/bin/bash
#Configure this, and also ensure you have the dev/build_data/osx.patch ready.
SRC="src"
NAME="pocketstrife"
VERSION=0.8.0
GIT=`git log --pretty=format:'%h' -n 1`

# *.love
cd $SRC
zip -r ../${NAME}_${GIT}.love *
cd ..

# Temp Space
mkdir tmp

# WINDOWS
cat dev/build_data/love-$VERSION\-win-x86/love.exe ${NAME}_${GIT}.love > tmp/${NAME}_${GIT}.exe
cp dev/build_data/love-$VERSION\-win-x86/*.dll tmp/
cd tmp
zip -r ../${NAME}_win_[$GIT].zip *
cd ..
rm tmp/* -rf #tmp cleanup

# OS X
cp dev/build_data/love.app tmp/${NAME}_${GIT}.app -Rv
cp ${NAME}_${GIT}.love tmp/${NAME}_${GIT}.app/Contents/Resources/
patch tmp/${NAME}_${GIT}.app/Contents/Info.plist -i dev/build_data/osx.patch
cd tmp
zip -r ../${NAME}_osx_[$GIT].zip ${NAME}_${GIT}.app
cd ..
rm tmp/* -rf #tmp cleanup

# Cleanup
rm tmp -rf

#!/bin/bash
set -eo pipefail

BUILD_ROOT=`pwd`
rm -rf bin
mkdir bin

# building backend
echo "Building backend..."
cd $BUILD_ROOT/chatwheel_backend
esy 
echo "Finished building backend, moving..."
cp _esy/default/build/default/lib/chatwheel_backend.exe $BUILD_ROOT/bin/server
cp -r priv $BUILD_ROOT/bin/

# bulding frontend
echo "Building frontend..."
cd $BUILD_ROOT/chatwheel_frontend
esy
npm install
npm run webpack:production
echo "Finished building frontend, moving..."
cp -r build $BUILD_ROOT/bin/assets

echo "Finished building"

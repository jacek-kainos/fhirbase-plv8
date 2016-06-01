#! /bin/bash

set -e

COMMIT=`git rev-parse HEAD`
BUILD_DIR=build/$COMMIT

git submodule init
git submodule update

if [[ ! -d $BUILD_DIR ]]; then

  echo "Build new version of fhirbase $COMMIT"

  cd plpl
  npm install
  cd ..
  npm install

  mkdir -p $BUILD_DIR

  coffee utils/generate_schema.coffee -n > $BUILD_DIR/schema.sql
  coffee utils/generate_patch.coffee -n > $BUILD_DIR/patch.sql

  plpl/bin/plpl compile $BUILD_DIR/code.sql

  cat $BUILD_DIR/schema.sql > $BUILD_DIR/build.sql
  cat $BUILD_DIR/patch.sql >> $BUILD_DIR/build.sql
  cat $BUILD_DIR/code.sql >> $BUILD_DIR/build.sql
  echo $COMMIT > $BUILD_DIR/version

  cat $BUILD_DIR/code.sql >> $BUILD_DIR/patch.sql

  rm -f `pwd`/build/latest
  ln -s `pwd`/$BUILD_DIR `pwd`/build/latest
else
  echo "Build already exists for revision $COMMIT"
fi

#!/bin/sh

set -e

dir=$(dirname "$0")

cd

for d in bin tools; do
  [ -d $d ] || mkdir $d
done

cp $dir/zprofile .zprofile

mkdir -p Library/KeyBindings
cp $dir/DefaultKeyBinding.dict Library/KeyBindings/DefaultKeyBinding.dict

MAVEN_VERSION=3.6.3

[ -d tools/apache-maven-$MAVEN_VERSION ] || curl http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -C tools -x
ln -sf ../tools/apache-maven-$MAVEN_VERSION/bin/mvn bin/mvn

git config --global user.name "Andreas Veithen"
git config --global user.email "andreas.veithen@gmail.com"
git config --global github.user veithen

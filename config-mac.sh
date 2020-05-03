#!/bin/sh

set -e

cd $(dirname "$0")
dir=$(pwd)

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

[ -d tools/google-cloud-sdk ] || curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-290.0.1-darwin-x86_64.tar.gz | tar -C tools -x
ln -sf ../tools/google-cloud-sdk/bin/gcloud bin/gcloud

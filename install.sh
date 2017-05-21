#!/bin/sh

set -e

dir=$(readlink -m $(dirname "$0"))

cd

#wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

sudo apt-get update
sudo apt-get install -y --allow-unauthenticated \
  metacity light-themes gnome-panel gnome-settings-daemon gnome-terminal tightvncserver \
  openjdk-8-jdk openjdk-8-source openjdk-9-jdk-headless subversion libsvnclientadapter-java unzip docker.io haveged \
  google-chrome-stable libgnome2-bin ruby ruby-dev

for cmd in java jjs keytool orbd pack200 policytool rmid rmiregistry servertool tnameserv unpack200; do
  sudo update-alternatives --set $cmd /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/$cmd
done

for cmd in idlj jar jarsigner javac javadoc javah javap jcmd jdb jdeps jinfo jmap jps jrunscript jsadebugd jstack jstat jstatd rmic schemagen serialver wsgen wsimport xjc; do
  sudo update-alternatives --set $cmd /usr/lib/jvm/java-8-openjdk-amd64/bin/$cmd
done

sudo usermod -a -G docker $USER

[ -d .vnc ] || mkdir .vnc

grep -q '\.profile\.d' .profile || echo 'for part in $HOME/.profile.d/*; do . "$part"; done' >> .profile
[ -d .profile.d ] || mkdir .profile.d

[ -d eclipse ] || wget -qO- "http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/2/eclipse-java-neon-2-linux-gtk-x86_64.tar.gz&r=1" | tar xz

eclipse/eclipse -application org.eclipse.equinox.p2.director -nosplash \
  -repository https://dl.bintray.com/subclipse/releases/subclipse/4.2.x/,http://download.eclipse.org/tools/ajdt/46/dev/update,https://alfsch.github.io/eclipse-updates/workspacemechanic \
  -installIU org.tigris.subversion.subclipse.feature.group,org.eclipse.ajdt.feature.group,com.google.eclipse.mechanic.feature.feature.group

[ -d bin ] || mkdir bin

#wget -qO bin/che https://raw.githubusercontent.com/eclipse/che/master/che.sh
#chmod a+x bin/che

[ -d apache-maven-3.3.9 ] || wget -qO- http://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz | tar xz
ln -sf ../apache-maven-3.3.9/bin/mvn bin/mvn

[ -d apache-ant-1.9.7 ] || wget -qO- http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.7-bin.tar.gz | tar xz
ln -sf ../apache-ant-1.9.7/bin/ant bin/ant

cp "$dir/vnc" bin
chmod a+x "$dir/vnc"

[ -e .profile.d/mvn ] || echo 'export MAVEN_OPTS="-Xmx256m -Xms128m"' > .profile.d/mvn

[ -e .profile.d/che ] || echo 'export CHE_UTILITY_VERSION=nightly' > .profile.d/che

[ -e .profile.d/env ] || echo 'export EDITOR=vim' > .profile.d/env

# Versions from https://pages.github.com/versions/
sudo gem install jekyll -v 3.3.1


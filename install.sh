#!/bin/sh

set -e

dir=$(readlink -m $(dirname "$0"))

cd

#wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

sudo apt-get update
sudo apt-get install -y --allow-unauthenticated \
  metacity light-themes gnome-panel gnome-settings-daemon gnome-terminal tightvncserver \
  openjdk-8-jdk openjdk-8-source openjdk-9-jdk-headless subversion libsvnclientadapter-java unzip docker.io \
  google-chrome-stable libgnome2-bin

sudo update-java-alternatives -s /usr/lib/jvm/java-1.8.0-openjdk-amd64

sudo usermod -a -G docker $USER

[ -d .vnc ] || mkdir .vnc

grep -q run-parts .profile || echo 'for part in $HOME/.profile.d/*; do . "$part"; done' >> .profile
[ -d .profile.d ] || mkdir .profile.d

[ -d eclipse ] || wget -qO- "http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/1/eclipse-java-neon-1-linux-gtk-x86_64.tar.gz&r=1" | tar xz

eclipse/eclipse -application org.eclipse.equinox.p2.director -nosplash \
  -repository https://dl.bintray.com/subclipse/releases/subclipse/4.2.x/,http://download.eclipse.org/tools/ajdt/46/dev/update,https://alfsch.github.io/eclipse-updates/workspacemechanic \
  -installIU org.tigris.subversion.subclipse.feature.group,org.eclipse.ajdt.feature.group,com.google.eclipse.mechanic.feature.feature.group

[ -d bin ] || mkdir bin

[ -d apache-maven-3.3.9 ] || wget -qO- http://www-us.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz | tar xz
ln -sf ../apache-maven-3.3.9/bin/mvn bin/mvn

[ -d apache-ant-1.9.7 ] || wget -qO- http://www-us.apache.org/dist/ant/binaries/apache-ant-1.9.7-bin.tar.gz | tar xz
ln -sf ../apache-ant-1.9.7/bin/ant bin/ant

cp "$dir/vnc" bin
chmod a+x "$dir/vnc"

[ -e .profile.d/mvn ] || echo 'export MAVEN_OPTS="-Xmx256m -Xms128m"' > .profile.d/mvn


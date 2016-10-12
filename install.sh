#!/bin/sh

set -e

cd

#wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update
sudo apt-get install -y --allow-unauthenticated \
  metacity light-themes gnome-panel gnome-settings-daemon gnome-terminal tightvncserver \
  openjdk-8-jdk subversion libsvnclientadapter-java \
  google-chrome-stable libgnome2-bin

[ -d .vnc ] || mkdir .vnc

cat > .vnc/xstartup <<EOF
#!/bin/sh

export XKL_XMODMAP_DISABLE=1
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
#vncconfig -iconic &

gnome-panel &
gnome-settings-daemon &
metacity &
gnome-terminal &
EOF

chmod a+x .vnc/xstartup

cat > .vnc/tightvncserver.conf <<EOF
\$geometry = "2048x1024";
EOF

grep -q run-parts .profile || echo 'for part in $HOME/.profile.d/*; do . "$part"; done' >> .profile
[ -d .profile.d ] || mkdir .profile.d

cat > .profile.d/vnc <<EOF
pidfile=~/.vnc/\$(hostname):1.pid
if [ ! -e \$pidfile ] || [ "\$(readlink /proc/\$(cat \$pidfile)/exe)" != /usr/bin/Xtightvnc ]; then
  password=\$(openssl rand -base64 6)
  echo \$password | vncpasswd -f > ~/.vnc/passwd
  echo "VNC password: \$password"
  /usr/bin/tightvncserver
fi
EOF

[ -d eclipse ] || wget -qO- "http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/1/eclipse-java-neon-1-linux-gtk-x86_64.tar.gz&r=1" | tar xz

eclipse/eclipse -application org.eclipse.equinox.p2.director -nosplash \
  -repository https://dl.bintray.com/subclipse/releases/subclipse/4.2.x/,http://download.eclipse.org/tools/ajdt/46/dev/update,https://alfsch.github.io/eclipse-updates/workspacemechanic \
  -installIU org.tigris.subversion.subclipse.feature.group,org.eclipse.ajdt.feature.group,com.google.eclipse.mechanic.feature.feature.group

[ -d apache-maven-3.3.9 ] || wget -qO- http://www-us.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz | tar xz
[ -d bin ] || mkdir bin
ln -sf ../apache-maven-3.3.9/bin/mvn bin/mvn

[ -e .profile.d/mvn ] || echo 'export MAVEN_OPTS="-Xmx256m -Xms128m"' > .profile.d/mvn


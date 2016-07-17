mkdir ~/git
cd ~/git
git clone git://github.com/paradoxxxzero/gnome-shell-system-monitor-applet.git
mkdir -p ~/.local/share/gnome-shell/extensions
cd ~/.local/share/gnome-shell/extensions
ln -s ~/git/gnome-shell-system-monitor-applet/system-monitor@paradoxxx.zero.gmail.com
gnome-shell-extension-tool --enable-extension=system-monitor@paradoxxx.zero.gmail.com

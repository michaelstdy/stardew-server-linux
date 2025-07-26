#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Starting VNC & Desktop Setup...${NC}"
export DEBIAN_FRONTEND=noninteractive

echo -e "\n${YELLOW}--> Installing VNC & Desktop packages...${NC}"
apt-get update
apt-get install -y xfce4 xfce4-goodies tigervnc-standalone-server novnc websockify supervisor

echo -e "\n${YELLOW}--> Configuring VNC...${NC}"
mkdir -p /root/.vnc
cat <<EOF > /root/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r /root/.Xresources ] && xrdb /root/.Xresources
vncconfig -iconic &
dbus-launch --exit-with-session xfce4-session
EOF
chmod +x /root/.vnc/xstartup
(echo "vnc123" && echo "vnc123") | vncpasswd

echo -e "\n${YELLOW}--> Creating services for VNC and noVNC...${NC}"
cat <<EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true
[program:vncserver]
command=vncserver :1 -geometry 1280x720 -depth 24 -rfbauth /root/.vnc/passwd
[program:novnc]
command=/usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080
EOF

echo -e "\n${GREEN}AUTO SETUP COMPLETE! Starting VNC...${NC}"
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
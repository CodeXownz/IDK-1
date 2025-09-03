Use the official Ubuntu 22.04 base image
FROM ubuntu:22.04

Set the environment variable for NoVNC and VNC
ENV NOVNC_HOME="/usr/share/novnc"
ENV VNC_GEOMETRY="1280x720"

Install necessary packages:
- supervisor: To manage multiple services
- nginx: The web server
- xfce4 xfce4-goodies: A lightweight desktop environment
- tightvncserver: The VNC server
- novnc: To provide web-based VNC access
RUN apt-get update && 

apt-get install -y supervisor nginx xfce4 xfce4-goodies tightvncserver novnc && 

apt-get clean && 

rm -rf /var/lib/apt/lists/*

Create a home directory for the user and set up VNC
RUN mkdir -p /root/.vnc && 

echo "password" | vncpasswd -f > /root/.vnc/passwd && 

chmod 600 /root/.vnc/passwd

Copy the supervisord configuration file into the container
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

Expose the ports for Nginx (80) and NoVNC (6080)
EXPOSE 80
EXPOSE 6080

Start supervisor, which will in turn start Nginx and the VNC server
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

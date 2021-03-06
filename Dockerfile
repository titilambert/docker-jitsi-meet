FROM debian:latest

MAINTAINER Thibault Cohen <thibault_cohen@manulife.com>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV JITDICHRID AAAAAAAAAAAAAAA
ENV JITSI_HOSTNAME localhost
#ENV JICOFO_AUTH_USER 
#ENV JICOFO_AUTH_DOMAIN 
#ENV JICOFO_AUTH_PASSWORD


VOLUME /var/log/jitsi
VOLUME /var/lib/prosody

EXPOSE 80 443 5347 4443 5280 5269 5222
EXPOSE 10000/udp 10001/udp 10002/udp 10003/udp 10004/udp 10005/udp 10006/udp 10007/udp 10008/udp 10009/udp 10010/udp

RUN apt-get update && \
	apt-get install -y wget dnsutils && \
	echo 'deb http://download.jitsi.org/nightly/deb unstable/' >> /etc/apt/sources.list && \
	wget -qO - https://download.jitsi.org/nightly/deb/unstable/archive.key | apt-key add - && \
	apt-get update && \
	apt-get -y install jitsi-meet && \
	apt-get clean

#ENV PUBLIC_HOSTNAME=192.168.59.103

#/etc/jitsi/meet/localhost-config.js = bosh: '//localhost/http-bind',
#RUN sed s/JVB_HOSTNAME=/JVB_HOSTNAME=$PUBLIC_HOSTNAME/ -i /etc/jitsi/videobridge/config && \
#	sed s/JICOFO_HOSTNAME=/JICOFO_HOSTNAME=$PUBLIC_HOSTNAME/ -i /etc/jitsi/jicofo/config

COPY output/chrome.crx /usr/share/jitsi-meet/
COPY output/chrome.pem /usr/share/jitsi-meet/


RUN ls
COPY run.sh /run.sh
CMD /run.sh

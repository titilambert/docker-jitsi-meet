set -x
set -e
unset DEBIAN_FRONTEND

export LOG=/var/log/jitsi/jvb.log
INITIAL_DATA=/var/lib/prosody.b

if [ -d "$INITIAL_DATA"]; then
    mv /var/lib/prosody.b /var/lib/prosody
fi

if [ ! -f "$LOG" ]; then
	
#	sed 's/#\ create\(.*\)/echo\ create\1 $JICOFO_AUTH_USER $JICOFO_AUTH_DOMAIN $JICOFO_AUTH_PASSWORD/' -i /var/lib/dpkg/info/jitsi-meet-prosody.postinst

    # Set hostname in the configuration
    echo '<a class="button icon-share-desktop" id="toolbar_button_download" data-container="body" data-toggle="popover" data-placement="bottom" content="Download Chrome Ext" href="chrome.crx"></a>'

    echo jitsi-videobridge jitsi-videobridge/jvb-hostname string ${JITSI_HOSTNAME} | debconf-set-selections -v
	dpkg-reconfigure -fnoninteractive jitsi-videobridge
	rm /etc/jitsi/jicofo/config && dpkg-reconfigure -fnoninteractive jicofo
#	/var/lib/dpkg/info/jitsi-meet-prosody.postinst configure
    # FIXME the first time the dpkg-reconfigure fail, the second time it works ...
    dpkg-reconfigure -fnoninteractive jitsi-meet-prosody || dpkg-reconfigure -fnoninteractive jitsi-meet-prosody
    if [ -z "${JITSI_CERT}" ]; then
    	dpkg-reconfigure -fnoninteractive jitsi-meet
    else
        # We need to handle the case where we already have a certificate
        echo "NOT IMPLEMENTED"
        exit 1
    fi

	touch $LOG && \
	chown jvb:jitsi $LOG
fi
# Set chrome ext ID
sed -i "s/desktopSharingChromeExtId:.*/desktopSharingChromeExtId: '${JITDICHRID}',/" /etc/jitsi/meet/jitsi-config.js
# Add Chrome ext link
sed -i '/share-desktop/a\                    <a class="button icon-share-desktop" id="toolbar_button_download" data-container="body" data-toggle="popover" data-placement="bottom" content="Download Chrome Ext" href="chrome.crx"></a>' /usr/share/jitsi-meet/index.html

cd /etc/init.d/

./prosody restart && \
./jitsi-videobridge restart && \
./jicofo restart && \
./nginx restart

tail -f $LOG

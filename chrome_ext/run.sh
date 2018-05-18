#!/bin/bash
set -e


Xvfb :1 -screen 0 1024x768x24 &
sleep 3
export DISPLAY=:1

sed -i "s/meet.jit.si/${JITSI_HOSTNAME}/" chrome/manifest.json
chromium --disable-gpu --pack-extension=chrome/
echo "Copy files in output folder"
cp -v chrome.* /output/

openssl genrsa 2048 | openssl pkcs8 -topk8 -nocrypt -out chrome.pem
openssl rsa -in chrome.pem -pubout -outform DER | openssl base64 -A
openssl rsa -in chrome.pem -pubout -outform DER |  shasum -a 256 | head -c32 | tr 0-9a-f a-p > /output/extensionID
echo
echo "#######################################"
echo "### CHROME EXTENTION ID":
echo "#######################################"
echo
cat /output/extensionID
echo
echo
echo "#######################################"
echo

#!/bin/bash


Xvfb :1 -screen 0 1024x768x24 &
sleep 3
export DISPLAY=:1

RUN sed -i "s/meet.jit.si/${JITSI_HOSTNAME}/" chrome/manifest.json
chromium --disable-gpu --pack-extension=chrome/
cp -v chrome.* /output/

2>/dev/null openssl genrsa 2048 | openssl pkcs8 -topk8 -nocrypt -out chrome.pem
2>/dev/null openssl rsa -in key.pem -pubout -outform DER | openssl base64 -A
2>/dev/null openssl rsa -in key.pem -pubout -outform DER |  shasum -a 256 | head -c32 | tr 0-9a-f a-p > /output/extensionID
cat /output/extensionID
echo

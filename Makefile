JITSI_HOSTNAME=jitsi

build_chrome_ext:
	cd chrome_ext && \
    docker build -t jitsi-chrome-ext . && \
    docker run \
    --privileged=true \
    --rm \
    -e JITSI_HOSTNAME=${JITSI_HOSTNAME} \
    -v `pwd`/../output:/output \
    jitsi-chrome-ext

build:
	docker build -t jitsi-meet .

run_rm:
	docker run --rm -it -e JITDICHRID=`cat output/extensionID` --name jitsi-meet -p 443:443 jitsi-meet

run:
	docker run \
    --name jitsi-meet \
    --hostname=jitsi \
    -it --rm \
    --net=host \
    -e JITDICHRID=`cat output/extensionID` \
    -e JITSI_HOSTNAME=${JITSI_HOSTNAME} \
    jitsi-meet
#    -v `pwd`/log/jitsi:/var/log/jitsi \
#    -v `pwd`/data:/var/lib/prosody \

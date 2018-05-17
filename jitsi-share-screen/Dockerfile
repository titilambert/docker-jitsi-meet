FROM debian

RUN apt-get update && apt-get install -y git chromium xvfb

RUN git clone https://github.com/jitsi/jidesha.git

WORKDIR /jidesha

ENV JITSI_HOSTNAME jitsi

COPY run.sh run.sh

CMD bash run.sh

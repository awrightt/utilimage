FROM debian:bullseye

LABEL maintainer="lonkaut@gmail.com"
ARG DEBIAN_FRONTEND=noninteractive

RUN \
apt-get update && \
apt-get install -y \
curl dnsutils procps \
tcpdump netcat python3 \
python3-pip lsof iproute2 \
zip vim xxd iputils-ping \
iputils-arping iputils-tracepath \
zsh

RUN \
python3 -m pip install -U pip && \
python3 -m pip install -U setuptools && \
python3 -m pip install -U wheel 

CMD ["true"]
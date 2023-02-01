FROM python:3.11.1-bullseye

LABEL maintainer="lonkaut@gmail.com"
ARG DEBIAN_FRONTEND=noninteractive

RUN \
echo "This section is reserved for addressing vulnerabilities" && \
echo 'deb http://deb.debian.org/debian bullseye-backports main' >> /etc/apt/sources.list && \
apt-get update && \
apt-get install -y \
git/bullseye-backports \ 
curl/bullseye-backports

RUN \
apt-get update && \
apt-get install -y \
curl dnsutils procps \
tcpdump netcat \
# python3 \
# python3-pip \
lsof iproute2 \
zip vim xxd iputils-ping \
iputils-arping iputils-tracepath \
zsh

RUN \
python3 -m pip install -U pip && \
python3 -m pip install -U setuptools && \
python3 -m pip install -U wheel && \
apt-get remove -y python3-pip python-pip-whl

CMD ["true"]
FROM python:3.11.1-bullseye


LABEL maintainer="lonkaut@gmail.com"
ARG DEBIAN_FRONTEND=noninteractive

RUN \
echo "This section is reserved for addressing vulnerabilities" && \
echo 'deb http://deb.debian.org/debian bullseye-backports main' >> /etc/apt/sources.list && \
apt-get update && \
apt-get autoremove -y libaom0 mariadb-common && \
apt-get install -y \
libcurl3-gnutls/bullseye-backports \ 
git/bullseye-backports \ 
curl/bullseye-backports && \
apt-get upgrade -y

RUN \
apt-get update && \
apt-get install -y -t bullseye-backports \
dnsutils procps \
tcpdump netcat \
# python3 \
# python3-pip \
lsof iproute2 \
zip vim xxd iputils-ping \
iputils-arping iputils-tracepath \
zsh openssh-client autojump fzf \
  && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
  && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
  && git clone https://github.com/frodenas/bosh-zsh-autocomplete-plugin.git ~/.oh-my-zsh/plugins/bosh \
  && sed -i 's/^plugins=.*/plugins=\(git\ zsh-autosuggestions\ zsh-syntax-highlighting\ bosh\ autojump\ fzf\ python\)/' $HOME/.zshrc

RUN \
python3 -m pip install -U pip && \
python3 -m pip install -U setuptools && \
python3 -m pip install -U wheel && \
apt-get remove -y python3-pip python-pip-whl

CMD ["true"]

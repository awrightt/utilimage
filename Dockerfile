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
dnsutils procps sudo \
tcpdump netcat \
lsof iproute2 \
zip vim xxd iputils-ping \
iputils-arping iputils-tracepath \
zsh openssh-client autojump 

RUN \
python3 -m pip install -U pip && \
python3 -m pip install -U setuptools && \
python3 -m pip install -U wheel && \
apt-get remove -y python3-pip python-pip-whl \
   && sudo apt-get autoremove -yq libapr1 libaprutil1 

RUN useradd -Um -u 1000 -G sudo  -d /home/sauce -s /usr/bin/zsh sauce \
  && sed -i 's/%sudo.*/%sudo\ \ \ ALL=NOPASSWD\:ALL/' /etc/sudoers 

USER 1000 
WORKDIR /home/sauce/
COPY .alias /home/sauce/

RUN touch ~/.zshrc \
  && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
  && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
  && sed -i 's/^plugins=.*/plugins=\(git\ zsh-autosuggestions\ zsh-syntax-highlighting\ autojump\ fzf\ python\)/' $HOME/.zshrc \
  && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k \
  && sed -i 's/^ZSH_THEME\=.*/ZSH_THEME\=\"powerlevel10k\/powerlevel10k\"/' $HOME/.zshrc \
  && curl -s -H "token: IGFsaWFzIGxsPSJleGEgLWxhIgog" https://node.kaut.io/api/data/power10k | base64 -d > $HOME/.p10k.zsh \
  && echo 'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' >> ~/.zshrc \ 
  # && echo 'source $HOME/.alias' >> $HOME/.zshrc \
  && sudo chown 1000:1000 $HOME/.alias

  # && sed -i '/^source\ \$HOME\/.alias/i eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' .zshrc \
#RUN [[ `uname -m` == aarch32 || `uname -m` == aarch64 ]] || sudo mkdir -p /home/linuxbrew/.linuxbrew \
RUN  sudo mkdir -p /home/linuxbrew/.linuxbrew \
  && sudo chown -R $(whoami) /home/linuxbrew \
  && echo '# Set PATH, MANPATH, etc., for Homebrew.' >> $HOME/.zshrc \
  && sed -i '/^POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD/a eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' .zshrc \
  # && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.zshrc \
  && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
  && /bin/bash -c "NONINTERACTIVE=1 $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
  && /home/linuxbrew/.linuxbrew/bin/brew install fzf 
  
RUN sed -i '/^plugins/ i export FZF_BASE=/home/linuxbrew/.linuxbrew/opt/fzf' $HOME/.zshrc \
    && /home/linuxbrew/.linuxbrew/opt/fzf/install --all \
    && /home/linuxbrew/.linuxbrew/bin/brew install lsd apr apr-util

RUN curl -sL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" | sudo tee /bin/kubectl >/dev/null \
    && sudo chmod a+rx /bin/kubectl    \
    && echo 'source $HOME/.alias' >> $HOME/.zshrc 


CMD ["true"]

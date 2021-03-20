FROM kalilinux/kali-rolling:latest as baseline

RUN apt-get -y update && DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata git curl wget zsh thunar



FROM baseline as builder

RUN \
    # Install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    sed -i '1i export LC_CTYPE="C.UTF-8"' /root/.zshrc && \
    sed -i '2i export LC_ALL="C.UTF-8"' /root/.zshrc && \
    sed -i '3i export LANG="C.UTF-8"' /root/.zshrc && \
    sed -i '3i export LANGUAGE="C.UTF-8"' /root/.zshrc && \
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    git clone --depth 1 https://github.com/zsh-users/zsh-history-substring-search /root/.oh-my-zsh/custom/plugins/zsh-history-substring-search && \
    sed -i 's/plugins=(git)/plugins=(git aws golang nmap node pip pipenv python ubuntu zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)/g' /root/.zshrc && \
    sed -i '78i autoload -U compinit && compinit' /root/.zshrc

# Change workdir
ENV DISPLAY=192.168.1.7:0.0
WORKDIR /



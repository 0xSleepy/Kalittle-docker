FROM kalilinux/kali-rolling:latest as baseline

RUN apt-get -y update && DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata git curl wget zsh



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

# BUILDER WORDLIST
FROM baseline as wordlist
RUN mkdir /temp
WORKDIR /temp

# Download wordlists
RUN \
    git clone --depth 1 https://github.com/xmendez/wfuzz.git && \
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git && \
    git clone --depth 1 https://github.com/fuzzdb-project/fuzzdb.git && \
    git clone --depth 1 https://github.com/daviddias/node-dirbuster.git && \
    git clone --depth 1 https://github.com/v0re/dirb.git && \
    curl -L -o rockyou.txt https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt && \
    curl -L -o all.txt https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt && \
    curl -L -o fuzz.txt https://raw.githubusercontent.com/Bo0oM/fuzz.txt/master/fuzz.txt

# WORDLIST
FROM builder as builder1
COPY --from=wordlist /temp/ /tools/wordlist/

# BUILDER OS ENUMERATION
FROM baseline as osEnumeration
RUN mkdir /temp
WORKDIR /temp

# Download htbenum
RUN git clone --depth 1 https://github.com/SolomonSklash/htbenum.git
WORKDIR /temp/htbenum
RUN \
    chmod +x htbenum.sh && \
    ./htbenum.sh -u

# Download linux smart enumeration
WORKDIR /temp
RUN git clone --depth 1 https://github.com/diego-treitos/linux-smart-enumeration.git
WORKDIR /temp/linux-smart-enumeration
RUN chmod +x lse.sh

# Download linenum
WORKDIR /temp
RUN git clone --depth 1 https://github.com/rebootuser/LinEnum.git
WORKDIR /temp/LinEnum
RUN chmod +x LinEnum.sh

# Download PEASS - Privilege Escalation Awesome Scripts SUITE
WORKDIR /temp
RUN \
    mkdir -p /temp/peass
WORKDIR /temp/peass
RUN \
    wget -q https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/raw/master/winPEAS/winPEASexe/binaries/Obfuscated%20Releases/winPEASany.exe && \
    wget -q https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/raw/master/winPEAS/winPEASexe/binaries/Obfuscated%20Releases/winPEASx64.exe && \
    wget -q https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/raw/master/winPEAS/winPEASexe/binaries/Obfuscated%20Releases/winPEASx86.exe && \
    wget -q https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/winPEAS/winPEASbat/winPEAS.bat && \
    wget -q https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/linPEAS/linpeas.sh

# OS ENUMERATION
FROM builder1 as builder2
COPY --from=osEnumeration /temp/ /tools/osEnumeration/
WORKDIR /tools/osEnumeration


# Change workdir
WORKDIR /


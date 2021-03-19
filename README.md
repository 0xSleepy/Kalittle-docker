# Kalittle-docker
A Kali-Linux dockerfile.

## Usage
    
    git clone https://github.com/0xSleepy/Kalittle-docker.git
    cd Kalittle
    docker build -t Kalittle .
    docker run --rm -it --name Kalittle /bin/zsh

### Options to run the contenair

You can use the contenair with differents options.

1. Run the contenair to acces on some CTF VPN. yeah some pewpew.
    
        docker run --rm -it --cap-add=NET_ADMIN --device=/net/tun --sysctl net.ipv6.conf.all.disable_ipv6=0 --name Kalittle /bin/zsh

2. Share directory from host machine and the contenair.

        docker run --rm -it -v /path:/kalittle --name kalittle /bin/zsh

3. Run GUI app in docker container on windows host.

    * Install VcXsrv 
    * For run GUI app from docker you need to get the IP of your windows host and set the DISPLAY env variable in the contenair. (The format of the display variable is [host]:<display>[.screen])
        
            export DISPLAY=YOURIP:0.0
# Kalittle-docker
A Kali-Linux dockerfile. You can customize the dockerfile for your own use.

## Usage
    
    git clone https://github.com/0xSleepy/Kalittle-docker.git
    cd Kalittle
    docker build -t Kalittle .
    docker run --rm -it --name Kalittle kalittle:latest /bin/zsh

### Options to run the contenair

You can use the contenair with differents options.

1. Run the contenair to acces on some CTF VPN. yeah some pewpew you know.

        docker run --rm -it --cap-add=NET_ADMIN --device=/dev/net/tun --sysctl net.ipv6.conf.all.disable_ipv6=0 --name Kalittle kalittle:latest /bin/zsh
   
2. Use -p flag for expose port. (The format of the -p command is [host port]:[container port]) 

        docker run --rm -it -p 9001 --name Kalittle kalittle:latest /bin/zsh
    
3. Share directory from host machine and the contenair.

        docker run --rm -it -v /path:/kalittle --name Kalittle kalittle:latest /bin/zsh

4. Run GUI app from docker container on windows host.

   * Install VcXsrv 
                
           export DISPLAY=$(ip route|awk '/^default/{print $3}'):0.0
        
    

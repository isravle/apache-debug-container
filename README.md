# apache-debug-container

Install:

sudo su
apt update + upgrade
docker build ./ -t apachecompile
docker run -d --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -p 0.0.0.0:80:80 -p 0.0.0.0:6060:6060  apachecompile
* --cap-add=SYS_PTRACE  -  GDB needS PTRACE, so we need to let the container this capability
* --security-opt seccomp=unconfined - GDB needs it also
Open browser, 127.0.0.1:6060

Commands 4 me
docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker build ./ -t apachecompile
docker run -d --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -p 0.0.0.0:80:80 -p 0.0.0.0:6060:6060 -p 0.0.0.0:1337:1337 apachecompile
docker exec -it $(docker ps -q) /bin/sh
Binary location: /usr/local/apache2/bin/httpd -X -D FOREGROUND
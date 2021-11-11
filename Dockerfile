FROM alpine:latest
WORKDIR /
 
## INSTALL SOME SHIT
RUN apk --update add gcc make g++ zlib-dev curl gdb python3 py3-pip python3-dev nano
 
## HTTP
RUN wget https://archive.apache.org/dist/httpd/httpd-2.4.48.tar.gz
RUN tar -xvzf httpd-2.4.48.tar.gz
RUN rm httpd-2.4.48.tar.gz
RUN mv ./httpd-2.4.48 ./httpd
WORKDIR /httpd/srclib
 
## APR
RUN wget https://archive.apache.org/dist/apr/apr-1.7.0.tar.gz
RUN tar -xvzf apr-1.7.0.tar.gz
RUN mv ./apr-1.7.0 apr
RUN rm apr-1.7.0.tar.gz
 
 
## APR-UTIL
RUN wget https://archive.apache.org/dist/apr/apr-util-1.6.1.tar.gz
RUN tar -xvzf apr-util-1.6.1.tar.gz
RUN mv ./apr-util-1.6.1 apr-util
RUN rm apr-util-1.6.1.tar.gz
 
## EXPAT
RUN wget  https://github.com/libexpat/libexpat/releases/download/R_2_4_1/expat-2.4.1.tar.gz
RUN tar -xvzf expat-2.4.1.tar.gz
RUN mv ./expat-2.4.1 expat
RUN rm expat-2.4.1.tar.gz
WORKDIR /httpd/srclib/expat/
RUN ./configure
RUN make
RUN make install
 
## PCRE
WORKDIR /httpd/srclib/
RUN wget http://ftp.cs.stanford.edu/pub/exim/pcre/pcre-8.45.tar.gz
RUN tar -xvzf pcre-8.45.tar.gz
RUN mv ./pcre-8.45 pcre
RUN rm pcre-8.45.tar.gz
WORKDIR /httpd/srclib/pcre/
RUN ./configure
RUN make
RUN make install
 
## COMPILE HTTPD
WORKDIR /httpd/
#RUN ./configure --enable-maintainer-mode --enable-debugger-mode --with-mpm=prefork --enable-mods-shared="all" --enable-proxy=shared
RUN ./configure --enable-debugger-mode --with-mpm=prefork --enable-proxy --enable-proxy-http
RUN make
RUN make install
 
## INSTALL GDB-GUI
ENV PATH="/root/.local/bin:${PATH}"
RUN python3 -m pip install --user pipx
RUN pipx install gdbgui
 
RUN echo "ProxyPass \"/google\" \"http://google.com\"" >> /usr/local/apache2/conf/httpd.conf
RUN echo "MaxClients 1" >> /usr/local/apache2/conf/httpd.conf
RUN sed -i -r 's/#LoadModule proxy_module/LoadModule proxy_module/' /usr/local/apache2/conf/httpd.conf
RUN sed -i -r 's/#LoadModule proxy_http_module/LoadModule proxy_http_module/' /usr/local/apache2/conf/httpd.conf
 
CMD  [ "gdbgui", "--host", "0.0.0.0", "--port", "6060"]
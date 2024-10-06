FROM debian:12.7

RUN apt-get -y update && apt-get -y upgrade && apt-get -y install --no-install-recommends \
  git ssh locales \
  && rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8

RUN echo "export XDG_CONFIG_HOME=~/.config" >> ~/.profile

RUN apt-get -y update && apt-get -y upgrade && apt-get -y install --no-install-recommends \
  build-essential automake libtool libc6-dev-i386 ca-certificates curl \
  openjdk-17-jdk maven \
  && rm -rf /var/lib/apt/lists/*

# # To compile for 32bit arch (multilib)
# RUN apt install gcc-multilib

# Also can remove achive
# Maven repository is stored globally
RUN cd ~ && curl -L -O https://github.com/antlr/antlr3/archive/refs/tags/3.5.3.tar.gz \
  && tar xzvf 3.5.3.tar.gz && cd ~/antlr3-3.5.3/runtime/C \
  && autoupdate && autoreconf -fi && LDFLAGS="-I/usr/include/x86_64-linux-gnu" CPPFLAGS="-I/usr/include/x86_64-linux-gnu" ./configure --enable-64bit \
  && make && make install \
  && mkdir -p /usr/local/maven/m2/repository && cd ~/antlr3-3.5.3 && mvn package install -Dmaven.test.skip=true -Dmaven.repo.local=/usr/local/maven/m2/repository \
  && rm -rf ~/antlr3-3.5.3

# Update LD_LIBRARY_PATH
RUN echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr-local.conf && ldconfig

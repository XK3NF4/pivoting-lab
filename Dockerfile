FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y \
    openssh-server \
    net-tools \
    iproute2 \
    curl \
    iptables \
    apache2 \
    wget \
    mtr-tiny \
    netcat-traditional \
    iputils-ping \
    sudo \
    && apt-get clean

RUN mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config


RUN echo "Listen 127.0.0.1:80" > /etc/apache2/ports.conf

EXPOSE 22

CMD ["/bin/sh", "-c", "service ssh start && apache2ctl -D FOREGROUND"]

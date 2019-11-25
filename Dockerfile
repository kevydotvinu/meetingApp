FROM ubuntu:16.04
COPY apache2.sh /vagrant/
RUN apt-get update && \
    apt-get -y install libapache2-mod-php php apache2 dateutils python3-pip && \
    rm -rf /var/lib/apt/lists/* && \
    chmod 777 /vagrant/apache2.sh && \
    useradd user && \
    mkdir -p /Public &&  \
    sh -c "(echo password; echo password) | smbpasswd -a -s user"

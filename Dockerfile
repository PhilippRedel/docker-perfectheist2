FROM ubuntu:20.04

RUN echo 'Acquire::http::Pipeline-Depth 0;' > /etc/apt/apt.conf.d/99fixbadproxy && \
    echo 'Acquire::http::No-Cache true;' > /etc/apt/apt.conf.d/99fixbadproxy && \
    echo 'Acquire::BrokenProxy    true;' > /etc/apt/apt.conf.d/99fixbadproxy && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    sed 's@archive.ubuntu.com@ftp.halifax.rwth-aachen.de/ubuntu/@' -i /etc/apt/sources.list

# Install dependencies and create steam user
RUN dpkg --add-architecture i386 && \
    apt-get update -o Acquire::CompressionTypes::Order::=gz && \
    apt-get install -y wget lib32gcc1 lib32stdc++6 lib32tinfo6 && \
    rm -r /var/cache/apt/archives/* && \
    useradd steam -m

WORKDIR /home/steam
USER steam

# Download steamcmd
RUN mkdir content Steam tmp && \
    cd Steam && \
    wget http://media.steampowered.com/client/steamcmd_linux.tar.gz && \
    tar xzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

# Download Garry's mod and content of tf2 and css
RUN ./Steam/steamcmd.sh +force_install_dir /home/steam/perfectheist2 +login anonymous +app_update 1964150 validate +quit && \
    # Cleanup
    rm -r /home/steam/tmp && \
    rm /home/steam/Steam/logs/*

RUN mkdir /home/steam/.steam/sdk64/

USER root
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

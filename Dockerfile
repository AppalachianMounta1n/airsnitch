FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install all dependencies from the README
RUN apt-get update && apt-get install -y \
    libnl-3-dev libnl-genl-3-dev libnl-route-3-dev \
    libssl-dev libdbus-1-dev pkg-config build-essential \
    net-tools python3-venv aircrack-ng rfkill git \
    dnsmasq tcpreplay macchanger sudo \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/airsnitch

# Clone the repo
RUN git clone https://github.com/vanhoefm/airsnitch.git .

# Build the modified hostap and Python environment
RUN bash setup.sh
RUN cd airsnitch/research && \
    bash build.sh && \
    bash pysetup.sh

WORKDIR /opt/airsnitch/airsnitch/research

# Activate the venv on every shell session
RUN echo "source /opt/airsnitch/airsnitch/research/venv/bin/activate" >> /root/.bashrc

CMD ["/bin/bash"]
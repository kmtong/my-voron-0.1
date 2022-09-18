FROM octoprint/octoprint

RUN apt install -y virtualenv python-dev libffi-dev build-essential \
    libncurses-dev libusb-dev avrdude gcc-avr binutils-avr avr-libc \
    stm32flash libnewlib-arm-none-eabi gcc-arm-none-eabi binutils-arm-none-eabi libusb-1.0 pkg-config

# do all download work before configuration
WORKDIR /opt
RUN git clone https://github.com/Klipper3d/klipper

# refer to install-debian.sh klipper script
RUN mkdir -p /opt/klippy-env
RUN virtualenv -p python2 /opt/klippy-env
RUN PIP_USER=false /opt/klippy-env/bin/pip install -r /opt/klipper/scripts/klippy-requirements.txt
RUN mkdir -p /octoprint/logs

# supervise s6 services
RUN mkdir -p /etc/services.d/klipper
COPY run-klipper /etc/services.d/klipper/run

# back to /octoprint dir
WORKDIR /octoprint

# for editing
RUN apt install -y vim

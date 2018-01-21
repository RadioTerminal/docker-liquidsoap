FROM ubuntu:16.04
MAINTAINER Stéphane Lepin <stephane.lepin@gmail.com>

# Create a dedicated user with passwordless sudo
USER root
RUN sed -i "s/jessie main/jessie main contrib non-free/" /etc/apt/sources.list
RUN sed -i "s/httpredir.debian.org/ftp.debian.org/" /etc/apt/sources.list
RUN apt-get update && apt-get install -y sudo
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:jonathonf/ffmpeg-3 -y

RUN useradd -m liquidsoap && echo 'liquidsoap ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Build and install liquidsoap
USER liquidsoap
WORKDIR /home/liquidsoap
RUN sudo apt-get install -y build-essential wget ocaml-findlib libao-ocaml-dev \
		libmad-ocaml-dev libtaglib-ocaml-dev libvorbis-ocaml-dev libladspa-ocaml-dev \
		libxmlplaylist-ocaml-dev libflac-dev libmp3lame-dev libcamomile-ocaml-dev \
		libpcre-ocaml-dev libfdk-aac-dev ffmpeg\
		libsamplerate-ocaml-dev libsoundtouch-ocaml-dev libdssi-ocaml-dev \
		liblo-ocaml-dev libyojson-ocaml-dev libopus-dev
ENV LIQ_MODULES="ocaml-opus ocaml-fdkaac ocaml-soundtouch ocaml-samplerate ocaml-dssi ocaml-xmlplaylist ocaml-lo ocaml-flac ocaml-mad ocaml-lame ocaml-ssl"
RUN	sudo wget https://github.com/savonet/liquidsoap/releases/download/1.3.3/liquidsoap-1.3.3-full.tar.gz -O- | tar xvzf - && \
	cd /home/liquidsoap/liquidsoap-1.3.3-full && cp PACKAGES.minimal PACKAGES && \
	for module in $LIQ_MODULES; do sed -i "s/#$module/$module/g" PACKAGES; done && \
	./configure && make && sudo make install && \
	cd /home/liquidsoap && rm -rf liquidsoap-1.3.3-full && sudo apt-get autoclean -y

VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/sudo", "-u", "liquidsoap", "liquidsoap", "/config/radio.liq"]


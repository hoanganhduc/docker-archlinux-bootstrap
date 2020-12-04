# Arch Linux using the official bootstrap file that can be used from any other distribution.
FROM scratch
MAINTAINER Duc A. Hoang

ADD pkgdir /
RUN pacman-key --init; \
    pacman-key --populate archlinux; \
    pacman -Syyuu --noconfirm base-devel; \
    rm /var/cache/pacman/pkg/*; \
    locale-gen;

ARG USERNAME=hoanganhduc
ARG USERHOME=/home/hoanganhduc
ARG USERID=1000
ARG USERGECOS='Duc A. Hoang'

RUN useradd \
	--create-home \
	--home-dir "$USERHOME" \
	--password "" \
	--uid "$USERID" \
	--comment "$USERGECOS" \
	--shell /bin/bash \
	"$USERNAME" && \
	echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN pacman -S --noconfirm --needed openssh git curl wget; \
	rm /var/cache/pacman/pkg/*

CMD /bin/bash

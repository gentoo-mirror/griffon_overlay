# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Shairport Sync is an AirPlay audio player"
HOMEPAGE="https://github.com/mikebrady/shairport-sync"
SRC_URI="https://github.com/mikebrady/shairport-sync/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64"

IUSE="alsa pulseaudio soundio soxr alac openssl mbedtls convolution"
REQUIRED_USE="|| ( alsa pulseaudio ) ^^ ( openssl mbedtls )"

RDEPEND="
	acct-user/shairport-sync
	acct-group/shairport-sync
	dev-libs/libconfig
	openssl? ( dev-libs/openssl )
	mbedtls? ( net-libs/mbedtls )
	net-dns/avahi
	soxr? ( media-libs/soxr )
	alsa? ( media-libs/alsa-lib )
	alac? ( media-libs/alac )
	pulseaudio? ( media-sound/pulseaudio )
	soundio? ( media-libs/libsoundio )
	dev-libs/libdaemon
	convolution? ( media-libs/libsndfile )
"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply "${FILESDIR}/gentoo-makefile-00.patch"
	eapply_user
}

src_configure() {
	autoreconf -i -f
	local myconf
	if use openssl ;then
		myconf="$myconf --with-ssl=openssl"
	elif use mbedtls ;then
		myconf="$myconf --with-ssl=mbedtls"
	fi
	if use alsa ;then
		myconf="$myconf --with-alsa"
	fi
	if use pulseaudio ;then
		myconf="$myconf --with-pa"
	fi
	if use soundio ;then
		myconf="$myconf --with-soundio"
	fi
	if use soxr ;then
		myconf="$myconf --with-soxr"
	fi
	if use alac ;then
		myconf="$myconf --with-apple-alac"
	fi
	if use convolution ;then
		myconf="$myconf --with-convolution"
	fi
	econf \
		--with-avahi \
		--with-metadata \
		--with-pipe \
		--with-stdout \
		--with-systemd \
		--with-systemv \
		--with-libdaemon \
		$myconf

}

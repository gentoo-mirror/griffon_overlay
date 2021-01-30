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

IUSE="alsa pulseaudio soxr systemd alac openssl mbedtls"
REQUIRED_USE="|| ( alsa pulseaudio ) ^^ ( openssl mbedtls )"

RDEPEND="
	dev-libs/libconfig
	openssl? ( dev-libs/openssl )
	mbedtls? ( net-libs/mbedtls )
	net-dns/avahi
	soxr? ( media-libs/soxr )
	alsa? ( media-libs/alsa-lib )
	alac? ( media-libs/libalac )
	pulseaudio? ( media-sound/pulseaudio )
	!systemd? ( dev-libs/libdaemon )
"
DEPEND="${RDEPEND}"

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
	if use soxr ;then
		myconf="$myconf --with-soxr"
	fi
	if ! use systemd ;then
		myconf="$myconf --with-libdaemon"
	fi
	if use alac ;then
		myconf="$myconf --with-apple-alac"
	fi
	econf \
		--with-avahi \
		--with-metadata \
		--with-pipe \
		--with-stdout \
		--with-systemd \
		--with-systemv \
		$myconf

}

src_install() {
	patch < "${FILESDIR}/gentoo-install.patch"
	emake DESTDIR="${D}" install
}

pkg_postinst()
{
	getent group shairport-sync &>/dev/null || groupadd -r shairport-sync >/dev/null
	getent passwd shairport-sync &> /dev/null || useradd -r -M -g shairport-sync -s /sbin/nologin -G audio shairport-sync >/dev/null
}

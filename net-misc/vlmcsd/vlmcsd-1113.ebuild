# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="KMS Emulator in C"
HOMEPAGE="https://github.com/Wind4/vlmcsd"
SRC_URI="https://github.com/Wind4/vlmcsd/archive/svn${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${PN}-svn${PV}"

src_compile() {
	emake
	emake man
}

src_install() {
	dobin ./bin/vlmcsd
	dobin ./bin/vlmcs

	dodir /etc/vlmcsd
	insinto /etc/vlmcsd
	doins ./etc/vlmcsd.ini
	doins ./etc/vlmcsd.kmd
	dodir /lib/systemd/system/
	insinto /lib/systemd/system/
	doins "${FILESDIR}/vlmcsd.service"

	doman ./man/vlmcs.1
	doman ./man/vlmcsd.ini.5
	doman ./man/vlmcsd.7
	doman ./man/vlmcsd.8
}

#!/bin/bash
# AXOS: builds the SD card image axos.img = boot | system | data.
# The data partition starts with the launcher in it, at the place LibreELEC
# installs used (/storage/tv-launcher), so updates and settings work the same.
# AXUS_PI: the unpacked "pi" folder of an AXUS release (tv-launcher-pi.tar.gz),
# with tv-launcher and apply-update.sh in it.
set -e
BOARD_DIR="$(dirname "$0")"
PI="${AXUS_PI:-$BR2_EXTERNAL_AXOS_PATH/axus/pi}"
[ -x "$PI/tv-launcher" ] || { echo "AXOS: AXUS launcher missing in $PI (unpack tv-launcher-pi.tar.gz there)"; exit 1; }

# files for the boot partition
FILES=()
for i in "${BINARIES_DIR}"/*.dtb "${BINARIES_DIR}"/rpi-firmware/*; do
	FILES+=( "${i#${BINARIES_DIR}/}" )
done
FILES+=( "zImage" )
BOOT_FILES=$(printf '\\t\\t\\t"%s",\\n' "${FILES[@]}")
GENIMAGE_CFG="${BINARIES_DIR}/genimage-axos.cfg"
sed "s|#BOOT_FILES#|${BOOT_FILES}|" "${BOARD_DIR}/genimage.cfg" > "${GENIMAGE_CFG}"

# what starts on the data partition
ROOTPATH_TMP="$(mktemp -d)"
trap 'rm -rf "${ROOTPATH_TMP}"' EXIT
S="${ROOTPATH_TMP}/storage"
mkdir -p "$S/tv-launcher/data" "$S/.config/system.d" "$S/videos"
install -m 755 "$PI/tv-launcher" "$S/tv-launcher/tv-launcher"
install -m 755 "$PI/apply-update.sh" "$S/tv-launcher/apply-update.sh"
echo 'TZ=CET-1CEST,M3.5.0,M10.5.0/3' > "$S/tv-launcher/env"
touch "$S/.config/tv-launcher.enabled"

rm -rf "${BUILD_DIR}/genimage.tmp"
genimage \
	--rootpath "${ROOTPATH_TMP}" \
	--tmppath "${BUILD_DIR}/genimage.tmp" \
	--inputpath "${BINARIES_DIR}" \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"
echo "AXOS image: ${BINARIES_DIR}/axos.img"

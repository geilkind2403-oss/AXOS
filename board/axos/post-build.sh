#!/bin/sh
# AXOS: the data partition at /storage (like LibreELEC, so the launcher runs
# unchanged), and the empty mount point in the system partition.
set -e
TARGET_DIR="$1"
mkdir -p "$TARGET_DIR/storage"
grep -q '/storage' "$TARGET_DIR/etc/fstab" || \
	echo '/dev/mmcblk0p3 /storage ext4 defaults,noatime 0 2' >> "$TARGET_DIR/etc/fstab"
# the launcher's service starts after the data partition is there
mkdir -p "$TARGET_DIR/etc/systemd/system/tv-launcher.service.d"
cat > "$TARGET_DIR/etc/systemd/system/tv-launcher.service.d/axos.conf" <<'C'
[Unit]
RequiresMountsFor=/storage
C
# No default password: root's login is locked ("*") until the owner sets
# one in Settings > System. SSH (dropbear) is off until switched on there.
sed -i 's/^root:[^:]*:/root:*:/' "$TARGET_DIR/etc/shadow"
rm -f "$TARGET_DIR"/etc/systemd/system/*.wants/dropbear.service

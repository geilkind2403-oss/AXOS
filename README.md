# AXOS

The operating system for the [AXUS](https://github.com/geilkind2403-oss/AXUS) launcher: a small Linux for the Raspberry Pi 3,
built with Buildroot, that boots straight into the launcher.

**Step 1 (now):** HDMI picture, the launcher, Wi-Fi/LAN (connman), Bluetooth (BlueZ),
sound (ALSA), TV remote (CEC), SSH (`root` / `axos`). No browser, no A/B updates yet.

## SD card

```
boot (FAT, 64 MB) | system (ext4, 400 MB) | storage (ext4, 256 MB → /storage)
```

`/storage` holds the launcher, its settings and data,so the launcher and its updates run unchanged. Each image starts with the
newest AXUS release; after that the launcher updates itself as usual.

## Build

GitHub: **Actions → AXOS image → Run workflow**. The result is `axos.img.xz` under the
run's artifacts. Flash it with Raspberry Pi Imager ("Use custom") onto a spare card.

Locally:

```bash
mkdir -p axus && curl -fsSL https://github.com/geilkind2403-oss/AXUS/releases/latest/download/tv-launcher-pi.tar.gz | tar -xz -C axus
git clone --branch 2025.02.x https://github.com/buildroot/buildroot
cd buildroot
make BR2_EXTERNAL=.. axos_rpi3_defconfig
make                                             # a few hours the first time
# → output/images/axos.img
```

## License

AXOS is free software under the **GNU General Public License v3.0** (see [LICENSE](LICENSE)).
The packages inside the image keep their own licenses (Linux, BusyBox and others: GPL-2.0;
glibc: LGPL). Every image release carries `axos-sources.tar.xz` with all their license texts
and their exact sources (Buildroot `legal-info`). The AXUS launcher in the image is the
release named in `axus.lock`, checked against its sha256 while building.

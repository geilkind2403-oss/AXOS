# AXOS

The operating system for the [AXUS](https://github.com/geilkind2403-oss/AXUS) launcher: a small Linux for the Raspberry Pi 3,
built with Buildroot, that boots straight into the launcher.

**Step 1 (now):** HDMI picture, the launcher, Wi-Fi/LAN (connman), Bluetooth (BlueZ),
sound (ALSA), TV remote (CEC), SSH (`root` / `axos`). No browser, no A/B updates yet.

## SD card

```
boot (FAT, 64 MB) | system (ext4, 400 MB) | storage (ext4, 256 MB → /storage)
```

`/storage` holds the launcher, its settings and dataso the launcher and its updates run unchanged. Each image starts with the
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

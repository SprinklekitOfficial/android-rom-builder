# 🔨 Android ROM Builder

Lightweight wrapper to build AOSP, LineageOS, and GrapheneOS ROMs from source.

## Requirements

**Linux** (Ubuntu 20.04+)
```bash
sudo apt install build-essential openjdk-11-jdk git-core gnupg flex bison gperf   zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev   x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip
```

## Setup

```bash
# Clone repo source (example: LineageOS)
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0
repo sync -j$(nproc)

# Copy builder
cp build.sh .
chmod +x build.sh
```

## Build

```bash
./build.sh lineage_davinci userdebug     # Build for Xiaomi Mi 9T
./build.sh lineage_bluejay user          # Pixel 6a release build
./build.sh aosp_redfin eng               # Pixel 4a engineer build
./build.sh <target> <variant> --clean    # Clean build
```

## GitHub Actions

Use the Actions workflow to build in the cloud:
1. Push to main
2. Go to Actions → Build ROM → Run workflow
3. Enter target and variant
4. Download artifact from job

---

*OutrageousStorm ROM builder — for AOSP-based distributions*

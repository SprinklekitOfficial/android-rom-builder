#!/usr/bin/env bash

echo "=== Очистка дискового пространства ==="
sudo rm -rf /usr/share/dotnet /usr/local/lib/android /opt/ghc /usr/libexec/docker
docker rmi $(docker images -q) 2>/dev/null

echo "=== Настройка Git и рабочих директорий ==="
git config --global user.name "Actions Builder"
git config --global user.email "builder@actions.com"

mkdir -p ~/bin
mkdir -p ~/android
# Исправленная прямая ссылка на raw-скрипт repo от Google
curl https://githubusercontent.com > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

cd ~/android
echo "=== Инициализация репозитория LineageOS ==="
repo init -u https://github.com -b lineage-20.0 --depth=1

echo "=== Добавление файлов устройства ==="
mkdir -p .repo/local_manifests
cat << 'EOF' > .repo/local_manifests/davinci.xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project path="device/xiaomi/davinci" name="LineageOS/android_device_xiaomi_davinci" remote="github" revision="lineage-20.0" />
  <project path="kernel/xiaomi/sm6150" name="LineageOS/android_kernel_xiaomi_sm6150" remote="github" revision="lineage-20.0" />
</manifest>
EOF

echo "=== Запуск синхронизации исходного кода ==="
repo sync -c -j$(nproc) --force-sync --no-clone-bundle --no-tags

echo "=== Начало компиляции операционной системы ==="
source build/envsetup.sh
breakfast davinci
brunch davinci

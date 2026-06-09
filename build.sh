#!/usr/bin/env bash

# 1. Очистка диска виртуальной машины, чтобы освободить 100+ ГБ пространства
echo "=== Очистка дискового пространства ==="
sudo rm -rf /usr/share/dotnet /usr/local/lib/android /opt/ghc /usr/libexec/docker
docker rmi $(docker images -q) 2>/dev/null

# 2. Настройка Git и рабочих директорий
git config --global user.name "Actions Builder"
git config --global user.email "builder@actions.com"
mkdir -p ~/bin ~/android
curl https://googleapis.com > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

# 3. Инициализация и скачивание исходников (Используем стабильный LineageOS 20)
cd ~/android
echo "=== Инициализация репозитория LineageOS ==="
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --depth=1

# 4. Скачивание дерева устройства Xiaomi Mi 9T (davinci)
echo "=== Добавление файлов устройства ==="
mkdir -p .repo/local_manifests
cat <<EOF > .repo/local_manifests/davinci.xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project path="device/xiaomi/davinci" name="LineageOS/android_device_xiaomi_davinci" remote="github" revision="lineage-20.0" />
  <project path="kernel/xiaomi/sm6150" name="LineageOS/android_kernel_xiaomi_sm6150" remote="github" revision="lineage-20.0" />
</manifest>
EOF

# 5. Синхронизация кода (Займет около 30-40 минут)
echo "=== Запуск синхронизации исходного кода ==="
repo sync -c -j$(nproc) --force-sync --no-clone-bundle --no-tags

# 6. Запуск компиляции прошивки
echo "=== Начало компиляции операционной системы ==="
source build/envsetup.sh
breakfast davinci
brunch davinci

#!/bin/bash
# build.sh -- Build AOSP/LineageOS ROM from source
# Usage: ./build.sh <target> <variant>
#        ./build.sh lineage_davinci userdebug
#        ./build.sh aosp_redfin user

set -e
BOLD='\033[1m'; GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'

TARGET="${1:?Usage: $0 <target> [variant]}"
VARIANT="${2:-userdebug}"
JOBS=$(nproc)
OUT_DIR="out/target/product/${TARGET#*_}"

echo -e "\n${BOLD}🔨 ROM Builder${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Target:   $TARGET"
echo "Variant:  $VARIANT"
echo "Jobs:     $JOBS"
echo "Out:      $OUT_DIR"

if [[ ! -f "build/make/core/main.mk" ]]; then
    echo -e "\n${RED}❌ Not in AOSP source directory${NC}"
    exit 1
fi

# Setup environment
echo -e "\n${BOLD}⚙️  Setting up environment...${NC}"
source build/envsetup.sh
lunch "${TARGET}-${VARIANT}" > /dev/null

# Wipe previous build
[[ "$3" == "--clean" ]] && { echo "Wiping out/..."; rm -rf out; }

# Build
echo -e "\n${BOLD}🏗️  Building ROM...${NC} (this may take 30 min to 2 hours)"
time mka bacon -j $JOBS 2>&1 | tee build.log

# Check result
ROM="${OUT_DIR}/$(grep 'TARGET_PRODUCT=' build.log | tail -1 | cut -d= -f2).zip" 2>/dev/null
if [[ -f "out/target/product/${TARGET#*_}/"*".zip" ]]; then
    ROM=$(ls -t out/target/product/${TARGET#*_}/*.zip 2>/dev/null | head -1)
    SIZE=$(du -h "$ROM" | cut -f1)
    echo -e "\n${GREEN}✅ Build successful!${NC}"
    echo -e "ROM: $(basename $ROM) ($SIZE)"
    echo -e "Path: $(realpath $ROM)"
else
    echo -e "\n${RED}❌ Build failed. Check build.log${NC}"
    tail -50 build.log
    exit 1
fi

# This build script is heavily inspired by the following:
# https://tangled.org/codedawa.dev/gutwound/blob/testing_odin_playdate_target/build.sh
# Keep in mind this script is designed for use on MacOS, and does not support other OSes (at this time)

# --- Project Metadata ---
proj_name := "OdinGame"

# --- Build Directories ---
playdate_sdk := env("PLAYDATE_SDK_PATH", "$HOME/Developer/PlaydateSDK")
build_dir := "build"
staging_dir := build_dir + "/staging"
pdx_dir := build_dir + "/" + proj_name + ".pdx"

cleanup:
    rm -rf "{{staging_dir}}" "{{pdx_dir}}"
    mkdir -p "{{staging_dir}}"

build: cleanup
    odin build src/ \
        -target:freestanding_arm32 \
        -subtarget:playdate \
        -build-mode:obj \
        -out:{{staging_dir}}/pdex \
        -default-to-nil-allocator \
        -no-thread-local \
        -disable-unwind
    arm-none-eabi-gcc \
        -I "{{playdate_sdk}}/C_API" \
        -DTARGET_PLAYDATE=1 \
        -DTARGET_EXTENSION=1 \
        -D__FPU_USED=1 \
        -D__HEAP_SIZE=8388208 \
        -D__STACK_SIZE=61800 \
        -mthumb \
        -mcpu=cortex-m7 \
        -mfloat-abi=hard \
        -mfpu=fpv5-sp-d16 \
        -nostartfiles \
        -T "{{playdate_sdk}}/C_API/buildsupport/link_map.ld" \
        -Wl,-Map={{staging_dir}}/pdex.map,--cref,--gc-sections,--no-warn-mismatch,--emit-relocs,--allow-multiple-definition,--defsym=__exidx_start=0,--defsym=__exidx_end=0 \
        -o "{{staging_dir}}/pdex.elf" \
        "{{playdate_sdk}}/C_API/buildsupport/setup.c" \
        {{staging_dir}}/pdex-*.o
    odin build src/ \
        -out:{{staging_dir}}/pdex.dylib \
        -build-mode:dll \
        -default-to-nil-allocator
    cp src/pdxinfo "{{staging_dir}}/pdxinfo"
    pdc "{{staging_dir}}" "{{pdx_dir}}"

run: build
    "/Applications/Playdate Simulator.app/Contents/MacOS/Playdate Simulator" {{pdx_dir}}

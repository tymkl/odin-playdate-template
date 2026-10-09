# Playdate Odin Template
This is a template for building games on the Playdate with Odin on MacOS.

Currently the build script (Justfile) is only designed for use on MacOS, but it may be extended in the future to 
support other operating systems.

This template also includes bindings for version 3.1.2 of the Playdate C SDK that were generated with the help of 
Karl Zylinski's [odin-c-bindgen](https://github.com/karl-zylinski/odin-c-bindgen).

## Building
Run `just build` to build the project into a .pdx package. Currently this build process builds it for use in both
the Playdate Simulator, as well as running on the device hardware. This is likely to change in the future.

## Running
Run `just run` to build the project and launch the Playdate Simulator (assuming you are on MacOS, and have the
Simulator placed in your Applications folder.)

## A Warning
This template is **very** work-in-progress, and the build script and generated bindings are likely to change over time.

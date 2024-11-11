# MCPU - Minecraft Implementation

This repository contains the schematics for the WIP
Minecraft implementation of the MCPU, and some extras:

Included are some components in the CPU as individual files,
such as the stackable binary comparator, IMM stage, hex displays, 

Also included is a ComputerCraft program to emulate memory that can provide both
practically unlimited ROM/RAM for any word-size, and easy debugging on it's
output by displaying a hex dump of memory near RAM/ROM address, and making loading
of hex-dumps possible even from the browser.

The img/ directory contains high-resolution renders of the CPU:

The web-based assembler/emulator can be found at [github.com/max1220/web-mcpu](https://github.com/max1220/web-mcpu)

![CPU slice](/img/cpu_slice_top_transparent.png)

![Full CPU with display](/img/cpu_full.jpg)

[YouTube demo video](https://www.youtube.com/watch?v=8l--4LuFrG8)


# License

All schematics included in this repository are public-domain
(they are almost completely just simple combinations of common redstone circuits).

The ComputerCraft code is MIT licensed.

# OpenJ9 Build Scripts

A set of scripts to simplify configuration and compilation of OpenJ9 (non only)
for RISC-V on Debian.

**These scripts were created solely for my personal needs while working on
OpenJ9 on RISC-V and mainly as an executable documentation. By no means they're
meant to be used for any kind of production. Use with caution!**

## Usage

1. To checkout code:

   ````
   ./prepare.sh
   ````

   This checks out OpenJDK, OpenJ and OMR and also downloads and unpacks
   freemarker. Source is checked out into `openj9-openjdk-jdk11` directory

2. Apply some out-of-tree patches:

   ````
   ./patch.sh
   ````

   Some of the patches are necessary - at the time of writing - to compile OpenJ9
   with GCC 10 (the GCC used on Debian for RISC-V). Some other ease debugging.


3. Configure build:

   ````
   ./configure.sh --target riscv64-linux-gnu
   ````

   By default, this configures build for debugging, i.e, with debug info and
   no optimization (`-O0`). You may specify `--release` option configure for
   a "release" build.

   Cross-compilation is only supported (so far) for RISC-V target on x86_64 hosts

4. Compile:

   ````
   ./compile.sh --target riscv64-linux-gnu
   ````

   You **must** specify the same `--target` as when configuring. If you specified
   `--release` when configuring, you **must** pass it to `compile.sh` too.
   (this annoyance may be fixed later)


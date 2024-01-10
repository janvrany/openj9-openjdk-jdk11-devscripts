

HOST="$(uname -m)-linux-gnu"
TARGET="$HOST"
CONFIG=slowdebug

_params=""

while (( "$#" )); do
  case "$1" in
    --debug)
      CONFIG=slowdebug
      shift
      ;;
    --release)
      CONFIG=release
      shift
      ;;
    --target)
      TARGET=$2
      shift 2
      ;;
    *) # preserve positional arguments
      _params="${_params} $1"
      shift
      ;;
  esac
done

eval set -- ${_params}

# Sanity checks
case "${TARGET}" in
		x86_64-linux-gnu)
			;;
		riscv64-linux-gnu)
			;;
		aarch64-linux-gnu)
			;;
		*)
			echo "Error: only 'x86_64-linux-gnu', 'riscv64-linux-gnu' and 'aarch64-linux-gnu' targets are supported (not '${TARGET}')"
			exit 2
		;;
esac

if test "${CONFIG}" != "slowdebug" -a "${CONFIG}" != "release"; then
	echo "Error: only 'slowdebug' and 'release' configs are supported (not '${CONFIG}')"
	exit 2
fi

# Setup build JDK
if [ -x "jdk/bin/javac" ]; then
	export JAVA_HOME="$(pwd)/jdk"
elif [ -z "${JAVA_HOME}" ]; then
	export JAVA_HOME=$(echo /usr/lib/jvm/java-11-openjdk-*)
fi
export PATH=$JAVA_HOME/bin:$PATH

if test "${HOST}" != "${TARGET}" ; then
	case "${TARGET}" in
		x86_64-linux-gnu)
			CONF=linux-x86_64-normal-server-slowdebug
			;;
		riscv64-linux-gnu)
			CONF=linux-riscv64-normal-server-slowdebug
			if [[ -f "/usr/bin/riscv64-linux-gnu-g++" ]]; then
				export RISCV_TOOLCHAIN_TYPE=install
			fi

			if [ -d "/opt/riscv/sysroot" ]; then
				SYSROOT="/opt/riscv/sysroot"
			elif [ -d "/opt/cross/riscv64" ]; then
				SYSROOT="/opt/cross/riscv64"
	elif [ -d "/usr/gnemul/qemu-riscv64" ]; then
		SYSROOT="/usr/gnemul/qemu-riscv64"
			else
				echo "ERROR: no cross-compilation sysroot found!"
				exit 2
			fi
			;;
		aarch64-linux-gnu)
			CONF=linux-aarch64-normal-server-slowdebug
			SYSROOT=
			for dir in "/opt/aarch64/sysroot" "/opt/cross/aarch64" "$HOME/Projects/debian-for-toys/arm64/build/root"; do
				if [ -d "$dir" ]; then
					SYSROOT="$dir"
					break
				fi
			done
			if [ -z "$SYSROOT" ]; then
				echo "ERROR: no cross-compilation sysroot found!"
				exit 2
			fi
			;;
	esac
fi

if test "${HOST}" == "${TARGET}"; then
	gcc=gcc
else
	gcc="${TARGET}-gcc"
fi
gcc_ver=$($gcc -dumpversion)

CFLAGS="-gdwarf-4"

if expr $gcc_ver \>= 12; then
	CFLAGS="$CFLAGS -Wno-error=use-after-free -Wno-error=dangling-pointer= -Wno-error=address -Wno-error=maybe-uninitialized"
fi

if expr $gcc_ver \>= 13; then
	CFLAGS="$CFLAGS -Wno-error=dangling-pointer= -Wno-error=address -Wno-error=maybe-uninitialized -Wno-error=narrowing"
fi

CXXFLAGS="$CFLAGS"
VMDEBUG="$CFLAGS"
VMLINK="$CFLAGS"


# Setup toolchain
if [ "${CONFIG}" == "slowdebug" ]; then
	export UMA_DO_NOT_OPTIMIZE_CCODE=1
	CFLAGS="${CFLAGS} -O0"
	CXXFLAGS="${CXXFLAGS} -O0"
	VMDEBUG="${VMDEBUG} -fno-inline -O0"
	VMLINK="${VMLINK} -O0"
	export enable_optimize=no
	export enable_optimized=no
fi

export CFLAGS
export CXXFLAGS
export VMDEBUG
export VMLINK
export BUILD_CONFIG="${CONFIG}"

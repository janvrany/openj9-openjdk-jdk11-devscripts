

HOST="$(uname -m)-linux-gnu"
TARGET="$HOST"
CONFIG=slowdebug

_params=""

while (( "$#" )); do
  case "$1" in
    --debug)
      CONFIG=debug
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
if test "${TARGET}" != "x86_64-linux-gnu" -a "${TARGET}" != "riscv64-linux-gnu"; then
	echo "Error: only 'x86_64-linux-gnu' and 'riscv64-linux-gnu' targets are supported (not '${TARGET}')"
	exit 2
fi

if test "${CONFIG}" != "slowdebug" -a "${CONFIG}" != "release"; then
	echo "Error: only 'slowdebug' and 'release' configs are supported (not '${CONFIG}')"
	exit 2
fi

# Setup build JDK
if [ -z "${JAVA_HOME}" ]; then
	export JAVA_HOME=$(echo /usr/lib/jvm/java-11-openjdk-*)
fi
export PATH=$JAVA_HOME/bin:$PATH

if test "${HOST}" != "${TARGET}" -a "${TARGET}" == "riscv64-linux-gnu"; then
	if [[ -f "/usr/bin/riscv64-linux-gnu-g++" ]]; then
		export RISCV_TOOLCHAIN_TYPE=install
	fi

	if [ -d "/opt/riscv/sysroot" ]; then
		SYSROOT="/opt/riscv/sysroot"
	elif [ -d "/opt/cross/riscv64" ]; then
		SYSROOT="/opt/cross/riscv64"
	else
		echo "ERROR: no cross-compilation sysroot found!"
		exit 2
	fi
fi

CFLAGS="-gdwarf-4"
CXXFLAGS="-gdwarf-4"
VMDEBUG="-gdwarf-4"
VMLINK="-gdwarf-4"


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

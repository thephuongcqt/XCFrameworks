set -e

updateXCconfig() {
	xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXXXXXXXX)
	trap 'rm -f "$xcconfig"' INT TERM HUP EXIT

	cat > "$xcconfig" <<- EOF
	MACH_O_TYPE = staticlib
	DEBUG_INFORMATION_FORMAT = dwarf
	ENABLE_BITCODE = NO
	SWIFT_VERSION = 5
	IPHONEOS_DEPLOYMENT_TARGET = 11.0	
    ENABLE_TESTING_SEARCH_PATHS=YES
	EOF
	export XCODE_XCCONFIG_FILE="$xcconfig"
}

updateXCconfig
carthage build --no-skip-current --use-xcframeworks --platform iOS
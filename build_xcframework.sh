set -e

WORKING_DIR="$(pwd)"

PROJECT_DIR="$WORKING_DIR"
BUILD_OUPUT_PATH="$WORKING_DIR/build"
TARGETS="XCFrameworks-Package"
IPHONE_ARCHIVE_PATH="archives/iphone_os.xcarchive"
IPHONE_FRAMEWORK_PATH="$IPHONE_ARCHIVE_PATH/Products/Library/Frameworks"
SIMULATOR_ARCHIVE_PATH="archives/iphonesimulator.xcarchive"
SIMULATOR_FRAMEWORK_PATH="$SIMULATOR_ARCHIVE_PATH/Products/Library/Frameworks"

build_iphone_os() {
    xcodebuild archive \
        -scheme "$1" \
        -sdk iphoneos \
        -archivePath $IPHONE_ARCHIVE_PATH \
        MACH_O_TYPE=staticlib \
        ENABLE_BITCODE=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        SKIP_INSTALL=NO \
        ENABLE_TESTING_SEARCH_PATHS=YES
}


build_simulator_os() {
    xcodebuild archive \
        -scheme "$1" \
        -sdk iphonesimulator \
        -archivePath $SIMULATOR_ARCHIVE_PATH \
        MACH_O_TYPE=staticlib \
        ENABLE_BITCODE=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        SKIP_INSTALL=NO \
        ENABLE_TESTING_SEARCH_PATHS=YES
}

create_xcframework() {
    NESTED_FRAMEWORKS=("$SIMULATOR_FRAMEWORK_PATH/*/")
    for item in $NESTED_FRAMEWORKS; do
        CURRENT_FRAMEWORK="$(basename $item)"
        CURRENT_FRAMEWORK_NAME="${CURRENT_FRAMEWORK/.framework/}"
        
        xcodebuild -create-xcframework \
            -framework "$IPHONE_FRAMEWORK_PATH/$CURRENT_FRAMEWORK" \
            -framework "$SIMULATOR_FRAMEWORK_PATH/$CURRENT_FRAMEWORK" \
            -output "$BUILD_OUPUT_PATH/$CURRENT_FRAMEWORK_NAME.xcframework"
    done    
}

rm -rf $BUILD_OUPUT_PATH
mkdir $BUILD_OUPUT_PATH

cd $PROJECT_DIR

for TARGET in $TARGETS; do
    build_iphone_os $TARGET
    build_simulator_os $TARGET
    create_xcframework
done

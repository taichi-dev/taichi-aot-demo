#!/bin/bash
set -e

[ -z "$1" ] && echo "demo name is not specified" && exit -1
ls "${PWD}/framework/android/app/src/main/jniLibs/arm64-v8a/lib$1_android.so"
[ ! -f "${PWD}/framework/android/app/src/main/jniLibs/arm64-v8a/lib$1_android.so" ] && echo "'$1' is not a valid demo" && exit -1

echo "building $1"

pushd framework/android

echo > local.properties
echo "sdk.dir=$ANDROID_SDK_ROOT" >> local.properties

java \
    "-DlibName=$1" \
    "-Dorg.gradle.appname=$1" \
    "-Dhttps.proxyHost=127.0.0.1" \
    "-Dhttps.proxyPort=1080" \
    "-Dhttp.nonProxyHosts=*.nonproxyrepos.com|localhost" \
    -classpath "gradle/wrapper/gradle-wrapper.jar" \
    org.gradle.wrapper.GradleWrapperMain build

popd

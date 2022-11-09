#!/bin/sh

set -ex

function build_demos {
  rm -rf build
  mkdir build
  CMAKE_ARGS=$1

  pushd build
  cmake $CMAKE_ARGS ..
  make -j
  popd
}


function run_headless_demos {
  # Do not use pushd, it's not available on android
  echo "Running headless demos"
  rm -rf output
  mkdir output

  HEADLESS_DIR="build/headless"
  cd $HEADLESS_DIR
  BINARIES=$(ls E*)
  cd -
  for b in $BINARIES; do
    rm -f *.bmp
    ./$HEADLESS_DIR/$b
    if [[ -f "0001.bmp" ]]; then
      mv 0001.bmp "output/$b.bmp"
    fi
  done
}


function compare_to_groundtruth {
  OS=$1
  case $OS in
    linux|android)
      echo "Comparing to $OS groundtruth"
      ;;
    *)
      echo "Unkwown OS: $OS"
      exit 1
      ;;
  esac

  OUTPUT_DIR=output
  pushd $OUTPUT_DIR
  BMPS=$(ls *.bmp)
  popd

  for b in $BMPS; do
    OUTPUT_FILE="$OUTPUT_DIR/$b"
    GROUNDTRUTH_FILE="ci/headless-truths/$OS/vulkan/$b"
    if [[ -f $GROUNDTRUTH_FILE ]]; then
      if [[ $(cmp -l $OUTPUT_FILE $GROUNDTRUTH_FILE | wc -l) -gt 800 ]]; then
        echo "Above threshold: $OUTPUT_FILE"
        exit 1
      fi
    else
      # TODO: make this an error in the future
      echo "Missing groundtruth file: $GROUNDTRUTH_FILE"
    fi
  done
}

function run_tutorial_demos {
  echo "Running tutorial demos"
  ./build/tutorial/E0_tutorial_cgraph
  ./build/tutorial/E0_tutorial_kernel
}


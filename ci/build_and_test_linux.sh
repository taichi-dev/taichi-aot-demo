#!/bin/bash
set -ex


. $(dirname $0)/test_utils.sh

build_demos $1

run_tutorial_demos

run_headless_demos

compare_to_groundtruth linux

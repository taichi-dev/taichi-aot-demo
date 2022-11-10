#!/bin/sh

set -ex

. $(dirname $0)/test_utils.sh

run_tutorial_demos

run_headless_demos

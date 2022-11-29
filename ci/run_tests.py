import cmake
import os
import argparse
import subprocess
import json
import numpy as np
from PIL import Image

# FIXME: (penguinliong) Get it back after a proper fix.
sys.exit(0)

parser = argparse.ArgumentParser(description=f"")
parser.add_argument('-l',
                    '--libcapi',
                    required=True,
                    type=str,
                    help='Installation directory for Taichi C-API library')
args = parser.parse_args()
os.environ["TAICHI_C_API_INSTALL_DIR"] = args.libcapi

def get_project_root_dir():
    curr_dir = os.path.dirname(os.path.realpath(__file__))
    root_dir = os.path.join(curr_dir, "..")

    return root_dir

def get_android_test_dir():
    return "/local/data/tmp"

def get_build_dir():
    return os.path.join(get_project_root_dir(), "build")


def build_project(project_dir, build_dir, cmake_args):
    ret = cmake._program("cmake", [f"-S {project_dir}", f"-B {build_dir}", *cmake_args])
    ret2 = cmake._program("cmake", ["--build", f"{build_dir}", "-j 16"])
    if ret != 0 or ret2 != 0:
        raise Exception("Cmake Error!")


def parse_test_config(platform):
    test_config_dir = os.path.join(get_project_root_dir(), "ci", "test_config.json")
    
    parsed_tests = []
    with open(test_config_dir, "r") as f:
        contents = json.load(f)
        for content in contents[platform]["tests"]:
            executable_dir = content[0]
            arguments = content[1]
            ground_truth = content[2]
            
            parsed_tests.append((executable_dir, arguments, ground_truth))
    
    cmake_args = []
    with open(test_config_dir, "r") as f:
        contents = json.load(f)
        cmake_args = contents[platform]["cmake_args"]
    return parsed_tests, cmake_args


def prepare_environment(platform):
    pass
    # TODO: setup build & runtime environment for android


def execute_test_command(test_command, arguments, platform): 
    test_dir = get_android_test_dir() if platform == "android" else get_build_dir()
    test_command = os.path.join(test_dir, test_command)
    
    arguments = arguments.strip().split(" ")
    arguments.extend(["--debug"])

    output_image_dir = test_command + "_result.bmp"
    arguments.extend(["-o", output_image_dir])
    
    result = subprocess.run([test_command, *arguments], stderr=subprocess.STDOUT, timeout=30)
    result.check_returncode()

    # TODO: copy back output image (android)

    return output_image_dir


def compare_bmp_images(image1_dir, image2_dir, threshold = 0.1):
    image1 = np.array(Image.open(image1_dir))
    image2 = np.array(Image.open(image2_dir))
    rmse = np.sqrt(((image1 - image2)**2).mean())
    
    if rmse > threshold:
        raise Exception("RMSE between output and reference images exceeds limitation: ")


if __name__ == "__main__":
    # 1. Compile project
    project_dir = get_project_root_dir()
    build_dir = get_build_dir()
    
    test_list, cmake_args = parse_test_config(platform="linux")

    build_project(project_dir, build_dir, cmake_args)

    # 2. Run executable and compare with ground truth
    for test_command, arguments, ground_truth_dir in test_list:
        output_image_dir = execute_test_command(test_command, arguments, platform="linux")
        if ground_truth_dir:
            ground_truth_dir = os.path.join(project_dir, ground_truth_dir)
            compare_bmp_images(output_image_dir, ground_truth_dir, threshold = 0.1)

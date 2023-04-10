#!/bin/bash

############################################
# All rights reserved.                     #
# Copyright © 2023 - Christoph Rohde       #
# https://github.com/CodebyCR/New-Bazel-sh #
############################################

# ANSI Color
indigo='\033[0;34m'
cyan='\033[0;36m'
red='\033[0;30m'
color_reset='\033[0m'


# Ask for project name
printf "${indigo}Enter the bazel project name: ${color_reset}"
read -r projectName
printf "\n"

# chose Project directory
printf "${cyan}In which directory should the folder be created? (Leave blank for home directory)${color_reset}"
read path

if [ -z "$path" ]
then
  path=$HOME
fi

# check of valid path
if ! [ -d "$path" ]
then
  printf "${red}Path dosen't exists!${color_reset}"
  exit 1
fi

# change to chosen path
cd $path

# Create project directory and switch to it
mkdir $projectName
cd $projectName

# Create README.md file with project name
echo "# $projectName" > ReadMe.md

# Create .gitignore file
echo "
# Bazel
/bazel-*

# Mac OS
.DS_Store

" > .gitignore

# Create the bazel BUILD and .bazelrc files for formatting with buildifier
touch .bazelrc
touch BUILD.bazel
echo "# Bazel rc
build --color=yes
build --cxxopt=\"--std=c++20\"" >> .bazelrc
buildifier -lint=fix BUILD.bazel

# .bazelversion
echo "6.1.1" > .bazelversion

# Changelog.md
touch Changelog.md

# # .bazelproject for clion
# touch .bazelproject
# echo "
# directories:
#   .

# targets:
#     //...

# additional_languages:
#     cpp

# additional_build_flags:
#     --cxxopt=\"--std=c++20\"
#     --color=yes

# " >> .bazelproject




# Create WORKSPACE file
echo "workspace(name = \"$projectName\")

################################
# **GIT REPOSITORYs**
################################

load(\"@bazel_tools//tools/build_defs/repo:git.bzl\", \"git_repository\")

git_repository(
    name = \"com_google_googletest\",
    commit =\"1b18723e874b256c1e39378c6774a90701d70f7a\",
    remote = \"https://github.com/google/googletest\",
    # tag = \"release-1.13.0\",
)

" > WORKSPACE.bazel

# Create BUILD.bazel file for hello-world binary
echo '

cc_binary(
    name = "hello-world",
    srcs = ["main.cpp"],
    visibility = ["//visibility:public"],
    deps = ["//library:hello-library"],
)

' > BUILD.bazel

# Create main.cc file for the hello-world binary
echo '#include "library/hello.hpp"

int main(int argc, char** argv) {
    lib::hello();

    return 0;
}

' > main.cpp

# Create library directory
mkdir library
cd library

# Create BUILD.bazel file for my-library
echo '
package(default_visibility = ["//visibility:public"])

cc_library(
    name = "hello-library",
    srcs = glob(["*.cpp"]),
    hdrs = glob(["*.hpp"]),
    visibility = ["//visibility:public"],
)

' > BUILD.bazel

# Create a source and header file for the library
echo '#include <iostream>

namespace lib
{

    void hello()
    {
        std::cout << "Hello, world!" << std::endl;
    }

    auto test_function() -> std::string {
        return "Test";
    }

}


' > hello.cpp

echo '#pragma once
#include <iostream>

namespace lib
{

    void hello();

    auto test_function() -> std::string;

}
' > hello.hpp

# Return to project root directory
cd ..

# gtest
mkdir GTest
cd GTest

# Create demo test
echo '
#include <gtest/gtest.h>
#include "library/hello.hpp"

TEST(HelloTest, Test) {
    EXPECT_EQ(lib::test_function(), "Test");
}

' > hello_test.cpp

# Create BUILD.bazel file for gtest
echo '
package(default_visibility = ["//visibility:public"])

cc_test(
    name = "lib_gtest",
    srcs = glob(["GTest/*.cpp"]),
    #includes = ["googletest/include"],
    visibility = ["//visibility:public"],
    deps = [
        "//library:hello-library",
        "@com_google_googletest//:gtest_main",
    ],
)

' > BUILD.bazel

# Return to project root directory
cd ..

# create third_party directory
mkdir third_party
cd third_party

# Initialize Git repository and make initial commit
git init
git add .
git commit -m "Initial commit"

# Build everything
bazel build //...

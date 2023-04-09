#!/bin/bash

# ANSI Color
indigo='\033[0;34m'
color_reset='\033[0m'


# Ask for project name
printf "${indigo}Enter the bazel project name: ${color_reset}"
read -r projectName
printf "\n"

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


# Initialize Git repository and make initial commit
git init
git add .
git commit -m "Initial commit"

# Create WORKSPACE file
touch WORKSPACE.bazel

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

}


' > hello.cpp

echo '#pragma once

namespace lib
{

    void hello();

}
' > hello.hpp

# Return to project root directory
cd ..

# create third_party directory
mkdir third_party
cd third_party

# Create BUILD.bazel file for googletest
echo '
package(default_visibility = ["//visibility:public"])

cc_library(
    name = "googletest",
    srcs = glob(["googletest/src/*.cc"]),
    hdrs = glob(["googletest/include/**/*.h"]),
    includes = ["googletest/include"],
    visibility = ["//visibility:public"],
)

' > BUILD.bazel


# Build everything
bazel build //...

# New-Bazel-sh

A script that generates a build, test & run ready Bazel template project for C++.

## Installation

### If not already done install [bazel](https://github.com/bazelbuild/bazelisk) & [buildifier](https://github.com/bazelbuild/buildtools)

> brew install bazelisk

> brew install buildifier

### Make the script executable

> chmod 755 new_bazel.sh

### Run the script

> ./new_bazel.sh

## Commands within the demo project

### Build

> BUILD: bazel build //...

### Test

> bazel test //GTest:lib_gtest

### Run

> bazel run //:hello-world

---

## Template Support

| Library      | Support  |
| :----------- | :------: |
| Google Test  | &#10004; |
| Nlohman JSON |    -     |

---

## Genarated files

- [x] Changelog.md
- [x] ReadMe.md
- [x] .gitignore
- [x] .bazelversion
- [x] .bazelrc
- [x] .bazelproject
- [x] WORKSPACE.bazel
- [x] A demo Library
- [x] A demo Library test case
- [x] A third_party directory

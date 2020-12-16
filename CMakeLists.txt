include(.auto-cmake/core/header.cmake) # Start some auto-CMake configuration, get usefull variables

# If you want to do some personnal stuff, you can do it there using some variables/function defined in header.cmake. For exemple if you create a target that would be created later by auto-cmake, you can, autocmake will not touch the target.

cmake_minimum_required(VERSION 3.13)
project(ull C )


include(.auto-cmake/core/core.cmake) # Give the hand to auto-cmake






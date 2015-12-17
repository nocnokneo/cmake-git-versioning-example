cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project(cmake-git-versioning-example C)
include_directories(${CMAKE_BINARY_DIR})
add_executable(foobar main.c)
find_package(Git)
find_package(Hg)
add_custom_target(version
  ${CMAKE_COMMAND} -D SRC=${CMAKE_SOURCE_DIR}/foobar_version.h.in
                   -D DST=${CMAKE_BINARY_DIR}/foobar_version.h
                   -D GIT_EXECUTABLE=${GIT_EXECUTABLE}
                   -D HG_EXECUTABLE=${HG_EXECUTABLE}
                   -P ${CMAKE_SOURCE_DIR}/GenerateVersionHeader.cmake
  )
add_dependencies(foobar version)

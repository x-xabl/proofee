cmake_minimum_required(VERSION 2.8.4)
project(proofee)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES proofee.cpp ProofeeIndex.cpp ProofeeIndex.h)

add_executable(proofee ${SOURCE_FILES})
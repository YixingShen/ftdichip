cmake_minimum_required(VERSION 2.8.11)
project(ftdichip)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)

set(FTDI_INC ${CMAKE_CURRENT_SOURCE_DIR}/spi/include/linux)

add_subdirectory(spi)
add_subdirectory(i2c)
add_subdirectory(an255)
add_subdirectory(proj)

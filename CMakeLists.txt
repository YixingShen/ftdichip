cmake_minimum_required(VERSION 2.8.11)
project(ftdichip)

set(FTDI_INC ${CMAKE_CURRENT_SOURCE_DIR}/spi/include/linux)

add_subdirectory(spi)
add_subdirectory(i2c)
add_subdirectory(an255)
add_subdirectory(proj)

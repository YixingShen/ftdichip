
set(INFRA_DIR ${CMAKE_CURRENT_SOURCE_DIR}/infra/inc)
set(COMMON_DIR ${CMAKE_CURRENT_SOURCE_DIR}/common/inc)
set(I2C_DIR ${CMAKE_CURRENT_SOURCE_DIR}/toplayer/i2c/inc)
set(MIDDLELAYER_DIR ${CMAKE_CURRENT_SOURCE_DIR}/middlelayer/inc)

add_subdirectory(common)
add_subdirectory(infra)
add_subdirectory(middlelayer)
add_subdirectory(toplayer)

set(SOURCES
	./infra/src/ftdi_infra.c
	./common/src/ftdi_common.c
	./middlelayer/src/ftdi_mid.c
	./toplayer/i2c/src/ftdi_i2c.c
)

include_directories(${INFRA_DIR})
include_directories(${COMMON_DIR})
include_directories(${I2C_DIR})
include_directories(${MIDDLELAYER_DIR})
include_directories(${FTDI_INC})

add_library(MPSSE SHARED ${SOURCES})
target_link_libraries(MPSSE)



include_directories(${INFRA_DIR})
include_directories(${COMMON_DIR})
include_directories(${I2C_DIR})
include_directories(${MIDDLELAYER_DIR})
include_directories(${FTDI_INC})

include_directories(../inc)
add_library (middlelayer SHARED ftdi_mid.c)
target_link_libraries(middlelayer)

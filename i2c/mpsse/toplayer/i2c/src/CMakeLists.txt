include_directories(${INFRA_DIR})
include_directories(${COMMON_DIR})
include_directories(${I2C_DIR})
include_directories(${MIDDLELAYER_DIR})
include_directories(${FTDI_INC})

include_directories(../inc)
add_library (toplayer ftdi_i2c.c)


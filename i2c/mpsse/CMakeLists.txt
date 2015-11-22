
set(INFRA_DIR ${CMAKE_CURRENT_SOURCE_DIR}/infra/inc)
set(COMMON_DIR ${CMAKE_CURRENT_SOURCE_DIR}/common/inc)
set(I2C_DIR ${CMAKE_CURRENT_SOURCE_DIR}/toplayer/i2c/inc)
set(MIDDLELAYER_DIR ${CMAKE_CURRENT_SOURCE_DIR}/middlelayer/inc)

add_subdirectory(common)
add_subdirectory(infra)
add_subdirectory(middlelayer)
add_subdirectory(toplayer)

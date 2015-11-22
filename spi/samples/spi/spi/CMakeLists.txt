
option(LINUX "Set Linux" ON)

if(LINUX)
add_definitions(-D__linux)
add_definitions(-D__linux__)
endif()

#include_directories(${FTDI_INC})
include_directories(${SPI_DIR})

add_executable (sample-dynamic sample-dynamic.c)
target_link_libraries(sample-dynamic MPSSE)

#add_executable(sample-static sample-static.c)
#target_link_libraries(sample-static MPSSE)

###########################################################################
# @licence app begin@
# SPDX-License-Identifier: MPL-2.0
#
# Component Name: Replayer
#
# Author: Marco Residori
#
# Copyright (C) 2013, XS Embedded GmbH
# 
# License:
# This Source Code Form is subject to the terms of the
# Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with
# this file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# @licence end@
###########################################################################

message(STATUS "LOG-REPLAYER")
message(STATUS "WITH_DLT = ${WITH_DLT}")

find_package(PkgConfig)

set(LIB_SRCS ${CMAKE_SOURCE_DIR}/src/log-replayer.c)

set(LIBRARIES pthread)

if(WITH_DLT)
    set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}")
    find_package(DLT REQUIRED)
    add_definitions("-DDLT_ENABLED=1")
    include_directories( ${DLT_INCLUDE_DIRS} )
    set(LIBRARIES ${LIBRARIES} ${DLT_LIBRARIES})
endif()

add_executable(log-replayer ${LIB_SRCS})

target_link_libraries(log-replayer ${LIBRARIES})

message(STATUS "---------------------------------------------------------")




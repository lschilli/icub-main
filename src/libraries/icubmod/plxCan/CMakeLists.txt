# Copyright: (C) 2010 RobotCub Consortium
# Authors: Lorenzo Natale
# CopyPolicy: Released under the terms of the GNU GPL v2.0.

PREPARE_DEVICE(pcan TYPE PlxCan
    INCLUDE PlxCan.h 
    WRAPPER "")

if (NOT SKIP_pcan)
  FIND_PACKAGE(PLXCANAPI)

  IF (NOT PLXCANAPI_FOUND)
    MESSAGE("pcan: cannot find plxcanapi, turn off device")
  ELSE (NOT PLXCANAPI_FOUND)
        INCLUDE_DIRECTORIES(${YARP_INCLUDE_DIRS} 
                            ${CMAKE_CURRENT_SOURCE_DIR}
                            ${PLXCANAPI_INC_DIRS})

        #plx-api related define
        ADD_DEFINITIONS(-DPLX_LITTLE_ENDIAN -DPLX_LINUX -DGCC)
        yarp_add_plugin(pcan PlxCan.cpp PlxCan.h)

        TARGET_LINK_LIBRARIES(pcan ${PLXCANAPI_LIB} ${YARP_LIBRARIES})
        
        icub_export_library(pcan)
	
  ENDIF (NOT PLXCANAPI_FOUND)
  
endif (NOT SKIP_pcan)


# Usually, all you'll need to do is set the name of your library here.
# The rest of the file can remain unchanged in most cases.
SET(LIB_TARGET "bml")   # name used in ADD_LIBRARY(...)
SET(LIB_PKG "BML")      # name you want in FIND_PACKAGE(...)
SET(VERBOSE FALSE)

# We expect a <LIBRARY>_DIR variable to be available, pointing to
# the directory with this library in it.
SET(LIB_DIR ${${LIB_PKG}_DIR})
MESSAGE("${LIB_PKG} Library!!!!!!!!!!!!!!!!!!!!!")
IF(VERBOSE)
  MESSAGE("LOOKING FOR INCLUDE FLES IN ${${LIB_PKG}_DIR}/include")
ENDIF(VERBOSE)
SET(${LIB_PKG}_INCLUDE_DIRS ${${LIB_PKG}_DIR}/include/)

IF (NESTED_BUILD)
  SET(BML_LIBRARIES bml)
  MESSAGE ("NESTED_BUILD")
  IF(VERBOSE)	
    MESSAGE ("NESTED_BUILD")
    MESSAGE (STATUS "NESTED_BUILD")
  ENDIF(VERBOSE)
ELSE (NESTED_BUILD)
  MESSAGE ( "Not NESTED_BUILD")

  IF(VERBOSE)
   MESSAGE( "Looking at ${BML_DIR}/lib")
   MESSAGE( "Looking at ${BML_DIR}")
  ENDIF(VERBOSE)	

  FIND_LIBRARY(${LIB_PKG}_LIBRARIES ${LIB_TARGET} ${BML_DIR}/lib)
  FIND_LIBRARY(${LIB_PKG}_LIBRARIES ${LIB_TARGET} ${BML_DIR})
  
  

  IF (NOT ${LIB_PKG}_LIBRARIES)
    IF(VERBOSE)
    	MESSAGE("LIB not found. Looking for sub-configurations")
    ENDIF(VERBOSE)	
    # We may be on a system with "Release" and "Debug" sub-configurations
    FIND_LIBRARY(${LIB_PKG}_LIBRARIES_RELEASE ${LIB_TARGET} ${LIB_DIR}/release NO_DEFAULT_PATH)
    FIND_LIBRARY(${LIB_PKG}_LIBRARIES_DEBUG ${LIB_TARGET} ${LIB_DIR}/debug NO_DEFAULT_PATH)

    IF (${LIB_PKG}_LIBRARIES_RELEASE AND NOT ${LIB_PKG}_LIBRARIES_DEBUG)
		SET(${LIB_PKG}_LIBRARIES ${${LIB_PKG}_LIBRARIES_RELEASE} CACHE PATH "release version of library" FORCE)
    ENDIF (${LIB_PKG}_LIBRARIES_RELEASE AND NOT ${LIB_PKG}_LIBRARIES_DEBUG)

    IF (${LIB_PKG}_LIBRARIES_DEBUG AND NOT ${LIB_PKG}_LIBRARIES_RELEASE)
		SET(${LIB_PKG}_LIBRARIES ${${LIB_PKG}_LIBRARIES_DEBUG} CACHE PATH "debug version of library" FORCE)
    ENDIF (${LIB_PKG}_LIBRARIES_DEBUG AND NOT ${LIB_PKG}_LIBRARIES_RELEASE)

    IF (${LIB_PKG}_LIBRARIES_DEBUG AND ${LIB_PKG}_LIBRARIES_RELEASE)
		SET(${LIB_PKG}_LIBRARIES 
			optimized ${${LIB_PKG}_LIBRARIES_RELEASE}
			debug ${${LIB_PKG}_LIBRARIES_DEBUG}  CACHE PATH "debug and release version of library" FORCE)
    ENDIF (${LIB_PKG}_LIBRARIES_DEBUG AND ${LIB_PKG}_LIBRARIES_RELEASE)

  ENDIF (NOT ${LIB_PKG}_LIBRARIES)
	
ENDIF (NESTED_BUILD)

IF(${LIB_PKG}_INCLUDE_DIRS AND ${LIB_PKG}_LIBRARIES)
        SET(${LIB_PKG}_FOUND TRUE)
ELSE(${LIB_PKG}_INCLUDE_DIRS AND ${LIB_PKG}_LIBRARIES)
        SET(${LIB_PKG}_FOUND FALSE)
ENDIF(${LIB_PKG}_INCLUDE_DIRS AND ${LIB_PKG}_LIBRARIES)

# Add YARP dependencies
FIND_PACKAGE(YARP)
SET(${LIB_PKG}_LIBRARIES ${${LIB_PKG}_LIBRARIES} ${YARP_LIBRARIES})

IF(VERBOSE)
  MESSAGE("${LIB_PKG}_FOUND ${${LIB_PKG}_FOUND}")
ENDIF(VERBOSE)


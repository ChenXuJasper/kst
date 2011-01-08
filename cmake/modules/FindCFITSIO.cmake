
include(FindPkgConfig)

pkg_check_modules(CFITSIO CFITSIO)

if(CFITSIO_INCLUDEDIR AND CFITSIO_LIBRARIES)
	set(CFITSIO_LIBRARY -L${CFITSIO_LIBRARY_DIRS} ${CFITSIO_LIBRARIES})
else()
	set(CFITSIO_INCLUDEDIR CFITSIO_INCLUDEDIR-NOTFOUND CACHE STRING "" FORCE)
	FIND_PATH(CFITSIO_INCLUDEDIR fitsio.h
		HINTS
		ENV CFITSIO_DIR
		PATH_SUFFIXES include/cfitsio include
		PATHS
		)
	FIND_LIBRARY(CFITSIO_LIBRARIES cfitsio 
		HINTS
		ENV CFITSIO_DIR
		PATH_SUFFIXES lib
		PATHS
		)
endif()

message(STATUS "CFITSIO: ${CFITSIO_INCLUDEDIR}")
message(STATUS "CFITSIO: ${CFITSIO_LIBRARIES}")
IF(CFITSIO_INCLUDEDIR AND CFITSIO_LIBRARIES)
	MESSAGE(STATUS "CFITSIO found at ${CFITSIO_INCLUDEDIR}")
	SET(CFITSIO_INCLUDE_DIR ${CFITSIO_INCLUDEDIR} ${CFITSIO_INCLUDEDIR}/..)
    if (UNIX)
		SET(CFITSIO_LIBRARIES ${CFITSIO_LIBRARIES} m)
	endif()
	SET(CFITSIO 1)
	SET(cfitsio 1)
ELSE()
	MESSAGE(STATUS "CFITSIO not found.")
ENDIF()




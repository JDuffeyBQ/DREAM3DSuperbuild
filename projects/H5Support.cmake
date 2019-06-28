set(extProjectName "H5Support")

set(H5Support_VERSION "1.0.0.0")
message(STATUS "External Project: ${extProjectName}: ${H5Support_VERSION}")

set(H5Support_URL "https://github.com/BlueQuartzSoftware/H5Support")
set(H5Support_GIT_TAG "origin/develop")

if(WIN32)
  set(H5Support_INSTALL "${DREAM3D_SDK}/${extProjectName}-${H5Support_VERSION}")
else()
  set(H5Support_INSTALL "${DREAM3D_SDK}/${extProjectName}-${H5Support_VERSION}-${CMAKE_BUILD_TYPE}")
endif()

set_property(DIRECTORY PROPERTY EP_BASE ${DREAM3D_SDK}/superbuild)

if(WIN32)
  set(CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /GR /EHsc /MP")
  set(C_FLAGS "/DWIN32 /D_WINDOWS /W3 /MP")
  set(C_CXX_FLAGS -DCMAKE_CXX_FLAGS=${CXX_FLAGS} -DCMAKE_C_FLAGS=${C_FLAGS})
endif()

ExternalProject_Add(${extProjectName}
  GIT_REPOSITORY ${H5Support_URL}
  GIT_TAG ${H5Support_GIT_TAG}
  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}"
  SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}"
  BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${H5Support_INSTALL}"

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    ${C_CXX_FLAGS}
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT=${OSX_SDK}
    -DHDF5_DIR:PATH=${HDF5_CMAKE_PATH}
    -DQt5_DIR:PATH=${Qt5_CMAKE_PATH}
    -DH5Support_INSTALL_FILES:BOOL=ON
    -DH5Support_INCLUDE_QT_API:BOOL=ON

  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)

#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure NDE for building
file(APPEND ${DREAM3D_SDK_FILE} "\n")
file(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
file(APPEND ${DREAM3D_SDK_FILE} "# H5Support Library Location\n")
if(APPLE)
  file(APPEND ${DREAM3D_SDK_FILE} "set(H5Support_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${H5Support_VERSION}-\${BUILD_TYPE}/cmake/H5Support\" CACHE PATH \"\")\n")
elseif(WIN32)
  file(APPEND ${DREAM3D_SDK_FILE} "set(H5Support_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${H5Support_VERSION}/cmake/H5Support\" CACHE PATH \"\")\n")
else()
  file(APPEND ${DREAM3D_SDK_FILE} "set(H5Support_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${H5Support_VERSION}-\${BUILD_TYPE}/cmake/H5Support\" CACHE PATH \"\")\n")
endif()
file(APPEND ${DREAM3D_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${H5Support_DIR})\n")

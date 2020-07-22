set(extProjectName "span-lite")
set(spanLite_VERSION "0.7.0")
set(spanLite_GIT_TAG "v0.7.0")
message(STATUS "Building: ${extProjectName}: ${spanLite_VERSION}")

set(spanLite_INSTALL "${DREAM3D_SDK}/${extProjectName}-${spanLite_VERSION}")

ExternalProject_Add(${extProjectName}
  GIT_REPOSITORY "https://github.com/martinmoene/span-lite"
  GIT_PROGRESS 1
  GIT_TAG ${spanLite_GIT_TAG}

  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp"
  DOWNLOAD_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Download"
  SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source"
  BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${spanLite_INSTALL}"

  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DSPAN_LITE_OPT_BUILD_TESTS:BOOL=OFF
    -DSPAN_LITE_OPT_BUILD_EXAMPLES:BOOL=OFF

  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)

#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure DREAM3D for building
file(APPEND ${DREAM3D_SDK_FILE} "\n")
file(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
file(APPEND ${DREAM3D_SDK_FILE} "# span-lite\n")
file(APPEND ${DREAM3D_SDK_FILE} "set(span-lite_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${spanLite_VERSION}/lib/cmake/${extProjectName}\" CACHE PATH \"\")\n")
file(APPEND ${DREAM3D_SDK_FILE} "set(span-lite_VERSION \"${spanLite_VERSION}\" CACHE STRING \"\")\n")

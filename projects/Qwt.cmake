#--------------------------------------------------------------------------------------------------
# Are we building Qwt (ON by default)
#--------------------------------------------------------------------------------------------------
option(BUILD_QWT "Build Qwt" ON)
if(NOT BUILD_QWT)
  return()
endif()

set(extProjectName "qwt")
set(qwt_VERSION "6.1.5")
message(STATUS "Building: ${extProjectName} ${qwt_VERSION}: -DBUILD_QWT=${BUILD_QWT}")

set(qwt_url "https://github.com/BlueQuartzSoftware/DREAM3DSuperbuild/releases/download/v6.6/${extProjectName}-${qwt_VERSION}.tar.gz")

set(qwt_INSTALL "${DREAM3D_SDK}/${extProjectName}-${qwt_VERSION}-${qt5_version_full}")

set(qwtConfig_FILE "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/qwtconfig.pri")
set(qwtSrcPro_FILE "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/src.pro")
set(COMMENT "")
if(NOT APPLE)
  set(COMMENT "#")
endif()

get_filename_component(_self_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

configure_file(
  "${_self_dir}/patches/qwt/qwtconfig.pri.in"
  "${qwtConfig_FILE}"
  @ONLY
)

configure_file(
  "${_self_dir}/patches/qwt/src/src.pro.in"
  "${qwtSrcPro_FILE}"
  @ONLY
)

set(qwt_ParallelBuild "")
if(WIN32)
  set(qwt_BUILD_COMMAND "nmake")
else()
  set(qwt_BUILD_COMMAND "/usr/bin/make")
  set(qwt_ParallelBuild "-j${CoreCount}")
endif()

ExternalProject_Add(${extProjectName}
  DOWNLOAD_NAME ${extProjectName}-${qwt_VERSION}.zip
  URL ${qwt_url}
  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp"
  DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}
  SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}-${qwt_VERSION}"
  BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${qwt_INSTALL}"

  # GIT_REPOSITORY "https://github.com/BlueQuartzSoftware/Qwt.git"
  # GIT_PROGRESS 1
  # GIT_TAG "origin/v6.1.4"
  # TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  # STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp"
  # DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}
  # SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}-${qwt_VERSION}"
  # BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  # INSTALL_DIR "${qwt_INSTALL}"

  CONFIGURE_COMMAND ${Qt5_QMAKE_EXECUTABLE} <SOURCE_DIR>/qwt.pro
  PATCH_COMMAND ${CMAKE_COMMAND} -E copy ${qwtConfig_FILE} <SOURCE_DIR>/qwtconfig.pri
                COMMAND ${CMAKE_COMMAND} -E copy ${qwtSrcPro_FILE} <SOURCE_DIR>/src/src.pro
  BUILD_COMMAND ${qwt_BUILD_COMMAND} ${qwt_ParallelBuild}
  INSTALL_COMMAND ${qwt_BUILD_COMMAND} install

  # BUILD_IN_SOURCE 1
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
file(APPEND ${DREAM3D_SDK_FILE} "# Qwt ${qwt_VERSION} Library\n")
file(APPEND ${DREAM3D_SDK_FILE} "set(QWT_INSTALL \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${qwt_VERSION}-${qt5_version_full}\" CACHE PATH \"\")\n")
file(APPEND ${DREAM3D_SDK_FILE} "set(QWT_VERSION \"${qwt_VERSION}\" CACHE STRING \"\")\n")

# INPUT VARIABLES:
# SILO_PATCHES_DIR
# 64BIT_BUILD
# SILO_SOURCE_DIR
# SILO_INSTALL_DIR
if (64BIT_BUILD)
  set(silo_bin_dir SiloWindows/MSVC9/x64/Release)
else()
  set(silo_bin_dir SiloWindows/MSVC9/Win32/Release)
endif()


execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${SILO_SOURCE_DIR}/${silo_bin_dir}/silohdf5.lib"
          "${SILO_INSTALL_DIR}/lib/silohdf5.lib"

  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${SILO_SOURCE_DIR}/${silo_bin_dir}/silohdf5.dll"
          "${SILO_INSTALL_DIR}/bin/silohdf5.dll"

  # There's a config.h file in this directory that we shouldn't install.
  # That causes build problems with other projects.
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${SILO_SOURCE_DIR}/SiloWindows/include/silo.h"
          "${SILO_INSTALL_DIR}/include/silo.h"

  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${SILO_SOURCE_DIR}/SiloWindows/include/siloversion.h"
          "${SILO_INSTALL_DIR}/include/siloversion.h"
  )

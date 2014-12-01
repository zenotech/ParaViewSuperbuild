# Consolidates platform independent stub for paraview.bundle.cmake files.

include (paraview_version)

# Enable CPack packaging.
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY
  "ParaView is a scientific visualization tool.")
set(CPACK_PACKAGE_NAME "ParaView")
set(CPACK_PACKAGE_VENDOR "Kitware, Inc.")
set(CPACK_PACKAGE_VERSION_MAJOR ${pv_version_major})
set(CPACK_PACKAGE_VERSION_MINOR ${pv_version_minor})
if (pv_version_suffix)
  set(CPACK_PACKAGE_VERSION_PATCH ${pv_version_patch}-${pv_version_suffix})
else()
  set(CPACK_PACKAGE_VERSION_PATCH ${pv_version_patch})
endif()

set(CPACK_PACKAGE_FILE_NAME
    "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}-${package_suffix}")

# Don't import CPack yet, let the platform specific code get another chance at
# changing the variables.
# include(CPack)

# PARAVIEW_INSTALL_MANUAL_PDF is set before importing this file.
# This allows us to override the pdf downloading code for apple.
if (PARAVIEW_INSTALL_MANUAL_PDF)
  set (pdf_pv_version "4.0")
  # download an install manual pdf.
  install(CODE "
    # create the doc directory.
    file(MAKE_DIRECTORY \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/doc\")

    # download the manual pdf.
    file(DOWNLOAD \"http://www.paraview.org/files/v${pdf_pv_version}/ParaViewManual.v${pdf_pv_version}.pdf\"
        \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/doc/ParaViewManual.v${pv_version}.pdf\"
        SHOW_PROGRESS)
  ")
endif()

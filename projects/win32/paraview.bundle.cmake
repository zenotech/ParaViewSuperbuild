set(paraview_doc_dir "doc")
set(paraview_data_dir "data")
set(paraview_plugin_path "bin")
include(paraview.bundle.common)

# Set NSIS install specific stuff.
if (CMAKE_CL_64)
  # Change default installation root path for Windows x64.
  set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
endif ()

# URL to website providing assistance in installing your application.
set(CPACK_NSIS_HELP_LINK "http://paraview.org/Wiki/ParaView")
set(paraview_description "ParaView ${paraview_version_full}")
set(pvserver_description "pvserver ${paraview_version_full} (Server)")
set(pvdataserver_description "pvdataserver ${paraview_version_full} (Data-Server)")
set(pvrenderserver_description "pvrenderserver ${paraview_version_full} (Render-Server)")
set(pvpython_description "pvpython ${paraview_version_full} (Python Shell)")

#FIXME: need a pretty icon.
#set(CPACK_NSIS_MUI_ICON "${CMAKE_CURRENT_LIST_DIR}/paraview.ico")
#set(CPACK_NSIS_MUI_FINISHPAGE_RUN "bin/paraview.exe")

set(library_paths "lib")

if (QT_LIBRARY_DIR)
  list(APPEND library_paths
    "${QT_LIBRARY_DIR}")
endif ()

# Install paraview executables to bin.
foreach (executable IN LISTS paraview_executables)
  if (DEFINED "${executable}_description")
    list(APPEND CPACK_NSIS_MENU_LINKS
      "bin/${executable}.exe" "${${executable}_description}")
  endif ()

  superbuild_windows_install_program("${executable}"
    "${library_paths}")
endforeach()

foreach (paraview_plugin IN LISTS paraview_plugins)
  superbuild_windows_install_plugin("${paraview_plugin}.dll"
    "bin"
    "${library_paths}")
endforeach ()

set(plugins_file "${CMAKE_CURRENT_BINARY_DIR}/paraview.plugins")
paraview_add_plugin("${plugins_file}" ${paraview_plugins})

install(
  FILES       "${plugins_file}"
  DESTINATION "bin"
  COMPONENT   superbuild
  RENAME      ".plugins")

if (python_enabled)
  include(python.functions)
  superbuild_install_superbuild_python()

  superbuild_windows_install_python(
    MODULES paraview
            vtk
            ${python_modules}
    MODULE_DIRECTORIES  "${superbuild_install_location}/bin/Lib/site-packages"
                        "${superbuild_install_location}/lib/site-packages"
                        "${superbuild_install_location}/lib/paraview-${paraview_version}/site-packages"
    SEARCH_DIRECTORIES  "lib")

  if (matplotlib_enabled)
    install(
      DIRECTORY   "${superbuild_install_location}/bin/Lib/site-packages/matplotlib/mpl-data/"
      DESTINATION "bin/Lib/site-packages/matplotlib/mpl-data"
      COMPONENT   superbuild)
  endif ()

  superbuild_windows_install_python(
    MODULES vtk
    NAMESPACE "/paraview"
    MODULE_DIRECTORIES
            "${superbuild_install_location}/bin/Lib/site-packages"
            "${superbuild_install_location}/lib/site-packages"
            "${superbuild_install_location}/lib/paraview-${paraview_version}/site-packages"
    SEARCH_DIRECTORIES  "lib")
endif ()

if (paraviewweb_enabled)
  install(
    DIRECTORY   "${superbuild_install_location}/bin/Lib/site-packages/win32"
    DESTINATION "bin/Lib/site-packages"
    COMPONENT   "superbuild")
  install(
    FILES       "${superbuild_install_location}/bin/Lib/site-packages/pywin32.pth"
                "${superbuild_install_location}/bin/Lib/site-packages/pywin32.version.txt"
    DESTINATION "bin/Lib/site-packages"
    COMPONENT   "superbuild")

  install(
    FILES       "${superbuild_install_location}/lib/paraview-${paraview_version}/site-packages/paraview/web/defaultProxies.json"
    DESTINATION "bin/Lib/site-packages/paraview/web"
    COMPONENT   "superbuild")
  install(
    DIRECTORY   "${superbuild_install_location}/share/paraview/web"
    DESTINATION "share/paraview-${paraview_version}"
    COMPONENT   "superbuild")
endif ()

if (qt4_built_by_superbuild OR qt5_built_by_superbuild)
  # TODO: get a list of Qt plugins.
  foreach (qt_plugin IN LISTS qt_plugins)
    superbuild_windows_install_plugin("${qt_plugin}.dll"
      "bin"
      "${library_paths}")
  endforeach ()
endif ()

foreach (qt4_plugin_path IN LISTS qt4_plugin_paths)
  get_filename_component(qt4_plugin_group "${qt4_plugin_paths}" DIRECTORY)
  get_filename_component(qt4_plugin_group "${qt4_plugin_group}" NAME)

  superbuild_windows_install_plugin(
    "${qt4_plugin_path}"
    "plugins/${qt4_plugin_group}"
    "${library_paths}")
endforeach ()

paraview_install_extra_data()

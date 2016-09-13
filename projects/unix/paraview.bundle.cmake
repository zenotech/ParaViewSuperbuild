include(paraview-version)

set(paraview_doc_dir "share/paraview-${paraview_version}/doc")
set(paraview_data_dir "share/paraview-${paraview_version}/data")
include(paraview.bundle.common)

set(paraview_component ParaView)
include(paraview.bundle.unix)

# Other miscellaneous dependencies.
if (qt4_built_by_superbuild OR qt5_built_by_superbuild)
  # TODO: get a list of Qt plugins.
  foreach (qt_plugin IN LISTS qt_plugins)
    superbuild_unix_install_plugin("${qt_plugin}.so"
      "paraview-${paraview_version}"
      ";paraview-${paraview_version}"
      "paraview-${paraview_version}")
  endforeach ()
endif ()

if (paraview_has_gui)
  install(
    DIRECTORY   "${superbuild_install_location}/share/appdata"
    DESTINATION "share"
    COMPONENT   "${paraview_component}"
    USE_SOURCE_PERMISSIONS)
  install(
    DIRECTORY   "${superbuild_install_location}/share/applications"
    DESTINATION "share"
    COMPONENT   "${paraview_component}"
    USE_SOURCE_PERMISSIONS)
  install(
    DIRECTORY   "${superbuild_install_location}/share/icons"
    DESTINATION "share"
    COMPONENT   "${paraview_component}"
    USE_SOURCE_PERMISSIONS)
endif ()

if (paraviewweb_enabled)
  install(
    FILES       "${superbuild_install_location}/lib/paraview-${paraview_version}/site-packages/paraview/web/defaultProxies.json"
    DESTINATION "lib/python2.7/site-packages/paraview/web"
    COMPONENT   "${paraview_component}")
  install(
    DIRECTORY   "${superbuild_install_location}/share/paraview-${paraview_version}/www"
    DESTINATION "share/paraview-${paraview_version}"
    COMPONENT   "${paraview_component}")
endif ()
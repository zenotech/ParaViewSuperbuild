set(library_paths
  "${superbuild_install_location}/lib"
  "${superbuild_install_location}/lib/paraview-${paraview_version}")

if (QT_LIBRARY_DIR)
  list(APPEND library_paths
    "${QT_LIBRARY_DIR}")
endif ()

foreach (executable IN LISTS paraview_executables)
  superbuild_unix_install_program_fwd("${executable}"
    "lib/paraview-${paraview_version}"
    SEARCH_DIRECTORIES "${library_paths}")
endforeach ()

foreach (paraview_plugin IN LISTS paraview_plugins)
  superbuild_unix_install_plugin("lib${paraview_plugin}.so"
    "lib/paraview-${paraview_version}"
    "lib/paraview-${paraview_version}"
    SEARCH_DIRECTORIES  "${library_paths}"
    LOCATION            "lib/paraview-${paraview_version}/plugins/${paraview_plugin}/")
endforeach ()

set(plugins_file "${CMAKE_CURRENT_BINARY_DIR}/paraview.plugins")
paraview_add_plugin("${plugins_file}" ${paraview_plugins})

install(
  FILES       "${plugins_file}"
  DESTINATION "lib/paraview-${paraview_version}"
  COMPONENT   superbuild
  RENAME      ".plugins")

if (MESA_SWR_ENABLED AND
    (osmesa_built_by_superbuild OR mesa_built_by_superbuild))
  # FIXME(package): install using the install macros.
  install(
    FILES       "${superbuild_install_location}/lib/libswrAVX.so"
                "${superbuild_install_location}/lib/libswrAVX2.so"
    DESTINATION lib
    COMPONENT   superbuild)
endif ()

if (python_enabled)
  include(python.functions)
  superbuild_install_superbuild_python()

  superbuild_unix_install_python(
    LIBDIR              "lib/paraview-${paraview_version}"
    MODULES             paraview
                        vtk
                        ${python_modules}
    MODULE_DIRECTORIES  "${superbuild_install_location}/lib/python2.7/site-packages"
                        "${superbuild_install_location}/lib/paraview-${paraview_version}/site-packages"
    SEARCH_DIRECTORIES  "${library_paths}")

  superbuild_unix_install_python(
    MODULE_DESTINATION  "/site-packages/paraview"
    LIBDIR              "lib/paraview-${paraview_version}"
    MODULES             vtk
    MODULE_DIRECTORIES  "${superbuild_install_location}/lib/python2.7/site-packages"
                        "${superbuild_install_location}/lib/paraview-${paraview_version}/site-packages"
    SEARCH_DIRECTORIES  "${library_paths}")

  if (matplotlib_built_by_superbuild)
    install(
      DIRECTORY   "${superbuild_install_location}/lib/python2.7/site-packages/matplotlib/mpl-data/"
      DESTINATION "lib/python2.7/site-packages/matplotlib/mpl-data"
      COMPONENT   superbuild)
  endif ()
endif ()

if (mpi_built_by_superbuild)
  set(mpi_executables
    mpiexec)
  foreach (mpi_executable IN LISTS mpi_executables)
    superbuild_unix_install_plugin("${mpi_executable}"
      "lib"
      "bin")
  endforeach ()
endif ()

paraview_install_extra_data()

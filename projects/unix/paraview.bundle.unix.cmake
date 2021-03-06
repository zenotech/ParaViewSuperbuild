set(library_paths
  "${superbuild_install_location}/lib"
  "${superbuild_install_location}/lib/paraview-${paraview_version}")

if (Qt5_DIR)
  list(APPEND library_paths
    "${Qt5_DIR}/../..")
endif ()

set(include_regexes)
if (fortran_enabled)
  list(APPEND include_regexes
    ".*/libgfortran"
    ".*/libquadmath")
endif ()

set(exclude_regexes)
if (PARAVIEW_DEFAULT_SYSTEM_GL OR
    (mesa_built_by_superbuild OR osmesa_built_by_superbuild))
  list(APPEND exclude_regexes
    ".*/libglapi"
    ".*/libGL")
endif ()

foreach (executable IN LISTS paraview_executables)
  superbuild_unix_install_program_fwd("${executable}"
    "lib/paraview-${paraview_version}"
    SEARCH_DIRECTORIES  "${library_paths}"
    INCLUDE_REGEXES     ${include_regexes}
    EXCLUDE_REGEXES     ${exclude_regexes})
endforeach ()

foreach (paraview_plugin IN LISTS paraview_plugins)
  superbuild_unix_install_plugin("lib${paraview_plugin}.so"
    "lib/paraview-${paraview_version}"
    "lib/paraview-${paraview_version}"
    LOADER_PATHS    "${library_paths}"
    INCLUDE_REGEXES ${include_regexes}
    EXCLUDE_REGEXES ${exclude_regexes}
    LOCATION        "lib/paraview-${paraview_version}/plugins/${paraview_plugin}/")
endforeach ()

set(plugins_file "${CMAKE_CURRENT_BINARY_DIR}/paraview.plugins")
paraview_add_plugin("${plugins_file}" ${paraview_plugins})

install(
  FILES       "${plugins_file}"
  DESTINATION "lib/paraview-${paraview_version}"
  COMPONENT   superbuild
  RENAME      ".plugins")

if (mesa_libraries)
  set(suffix)
  if (PARAVIEW_DEFAULT_SYSTEM_GL)
    set(suffix "/mesa")
  endif ()

  foreach (mesa_library IN LISTS mesa_libraries)
    file(GLOB lib_filenames
      RELATIVE "${superbuild_install_location}/lib"
      "${superbuild_install_location}/lib/lib${mesa_library}.so*")

    foreach (lib_filename IN LISTS lib_filenames)
      superbuild_unix_install_plugin("${lib_filename}"
        "lib/paraview-${paraview_version}${suffix}"
        "lib"
        LOADER_PATHS  "${library_paths}"
        LOCATION      "lib/paraview-${paraview_version}${suffix}")
    endforeach ()
  endforeach ()
endif ()

if (python_enabled)
  include(python.functions)
  superbuild_install_superbuild_python(
    LIBSUFFIX "/paraview-${paraview_version}")

  superbuild_unix_install_python(
    LIBDIR              "lib/paraview-${paraview_version}"
    MODULES             paraview
                        vtk
                        ${python_modules}
    INCLUDE_REGEXES     ${include_regexes}
    EXCLUDE_REGEXES     ${exclude_regexes}
    MODULE_DIRECTORIES  "${superbuild_install_location}/lib/python2.7/site-packages"
                        "${superbuild_install_location}/lib/paraview-${paraview_version}/site-packages"
    LOADER_PATHS        "${library_paths}")

  superbuild_unix_install_python(
    MODULE_DESTINATION  "/site-packages/paraview"
    LIBDIR              "lib/paraview-${paraview_version}"
    MODULES             vtk
    INCLUDE_REGEXES     ${include_regexes}
    EXCLUDE_REGEXES     ${exclude_regexes}
    MODULE_DIRECTORIES  "${superbuild_install_location}/lib/python2.7/site-packages"
                        "${superbuild_install_location}/lib/paraview-${paraview_version}/site-packages"
    LOADER_PATHS        "${library_paths}")

  if (matplotlib_built_by_superbuild)
    install(
      DIRECTORY   "${superbuild_install_location}/lib/python2.7/site-packages/matplotlib/mpl-data/"
      DESTINATION "lib/python2.7/site-packages/matplotlib/mpl-data"
      COMPONENT   superbuild)
  endif ()

  if (NOT python_built_by_superbuild)
    install(CODE
      "execute_process(
        COMMAND \"${CMAKE_COMMAND}\" -E create_symlink
                ../python2.7/site-packages
                \$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/lib/paraview-${paraview_version}/site-packages
        ERROR_VARIABLE  out
        OUTPUT_VARIABLE out
        RESULT_VARIABLE res)

      if (res)
        message(FATAL_ERROR
          \"Failed to create the site-packages symlink: \${out}\")
      endif ()"
      COMPONENT superbuild)
  endif ()
endif ()

if (mpi_built_by_superbuild)
  set(mpi_executables_standalone
    mpiexec
    hydra_pmi_proxy)
  set(mpi_executables_paraview
    hydra_nameserver
    hydra_persist)
  foreach (mpi_executable IN LISTS mpi_executables_standalone)
    superbuild_unix_install_plugin("${superbuild_install_location}/bin/${mpi_executable}"
      "lib"
      "bin")
  endforeach ()
  foreach (mpi_executable IN LISTS mpi_executables_standalone mpi_executables_paraview)
    superbuild_unix_install_plugin("${superbuild_install_location}/bin/${mpi_executable}"
      "lib/paraview-${paraview_version}"
      "lib/paraview-${paraview_version}")
  endforeach ()
endif ()

if (qt5_enabled)
  file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/qt.conf" "")
  install(
    FILES       "${CMAKE_CURRENT_BINARY_DIR}/qt.conf"
    DESTINATION "lib/paraview-${paraview_version}"
    COMPONENT   superbuild)
endif ()

foreach (qt5_plugin_path IN LISTS qt5_plugin_paths)
  get_filename_component(qt5_plugin_group "${qt5_plugin_path}" DIRECTORY)
  get_filename_component(qt5_plugin_group "${qt5_plugin_group}" NAME)

  superbuild_unix_install_plugin("${qt5_plugin_path}"
    "lib/paraview-${paraview_version}"
    "lib/paraview-${paraview_version}/plugins/${qt5_plugin_group}/"
    LOADER_PATHS    "${library_paths}"
    INCLUDE_REGEXES ${include_regexes}
    EXCLUDE_REGEXES ${exclude_regexes})
endforeach ()

paraview_install_extra_data()

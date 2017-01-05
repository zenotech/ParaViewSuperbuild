if (BUILD_SHARED_LIBS)
  set(silo_shared_args --enable-shared --disable-static)
else ()
  set(silo_shared_args --disable-shared --enable-static)
endif ()

if (zlib_enabled)
  if (USE_SYSTEM_zlib)
    if (ZLIB_INCLUDE_DIRS AND ZLIB_LIBRARIES)
      list(GET ZLIB_INCLUDE_DIRS 0 silo_zlib_inc_dir)
      list(GET ZLIB_LIBRARIES 0 silo_zlib_lib)
      get_filename_component(silo_zlib_lib_dir "${silo_zlib_lib}" DIRECTORY)
      set(silo_zlib_args "--with-zlib=${silo_zlib_inc_dir},${silo_zlib_lib_dir}")
    endif ()
  else ()
    set(silo_zlib_args "--with-hdf5=<INSTALL_DIR>/include,<INSTALL_DIR>/lib")
  endif ()
endif ()

if (szip_enabled AND NOT USE_SYSTEM_szip)
  set(silo_szip_args --with-szlib=<INSTALL_DIR>)
endif ()

if (hdf5_enabled)
  if (USE_SYSTEM_hdf5)
    find_package(HDF5)
    if (HDF5_INCLUDE_DIRS AND HDF5_LIBRARIES)
      list(GET HDF5_INCLUDE_DIRS 0 silo_hdf5_inc_dir)
      list(GET HDF5_C_LIBRARIES 0 silo_hdf5_lib)
      get_filename_component(silo_hdf5_lib_dir "${silo_hdf5_lib}" DIRECTORY)
      set(silo_hdf5_args "--with-hdf5=${silo_hdf5_inc_dir},${silo_hdf5_lib_dir}")
    endif ()
  else ()
    set(silo_hdf5_args "--with-hdf5=<INSTALL_DIR>/include,<INSTALL_DIR>/lib")
  endif ()
endif ()

superbuild_add_project(silo
  DEPENDS_OPTIONAL zlib szip hdf5
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --disable-fortran
      --disable-browser
      --disable-silex
      ${silo_shared_args}
      ${silo_zlib_args}
      ${silo_szip_args}
      ${silo_hdf5_args})

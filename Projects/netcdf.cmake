add_external_project_or_use_system(netcdf
  DEPENDS hdf5 zlib

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=TRUE
    -DBUILD_TESTING:BOOL=FALSE
    -DBUILD_UTILITIES:BOOL=FALSE
    -DUSE_SZIP:BOOL=OFF
    -DENABLE_DAP:BOOL=OFF
)
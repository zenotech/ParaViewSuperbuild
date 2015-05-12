if(WIN32)
 message(FATAL_ERROR "CosmoTools is not supported on Windows!")
 return()
endif()

if(BUILD_SHARED_LIBS)
  set(lib_suffix ${CMAKE_SHARED_LIBRARY_SUFFIX})
else()
  set(lib_suffix ${CMAKE_STATIC_LIBRARY_SUFFIX})
endif()

add_external_project(cosmotools
    DEPENDS genericio diy qhull

    CMAKE_ARGS
        -DENABLE_DIY:BOOL=ON
        -DENABLE_QHULL:BOOL=ON
        -DBUILD_COSMOTOOLS_PROGRAMS:BOOL=OFF
        -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
        -DBUILD_SIMULATION_INTERFACE:BOOL=OFF
        -DBUILD_SINGLE_LIBRARY:BOOL=ON
        -DTYPE_IDS_64BITS:BOOL=ON
        -DDIY_INCLUDE_DIRS:PATH=${SuperBuild_BINARY_DIR}/diy/src/diy/include
        -DDIY_LIBRARIES:PATH=${SuperBuild_BINARY_DIR}/diy/src/diy/lib/libdiy.a
        -DQHULL_INCLUDE_DIRS:PATH=${SuperBuild_BINARY_DIR}/qhull/src/qhull/src/libqhull
        -DQHULL_LIBRARIES:PATH=${SuperBuild_BINARY_DIR}/qhull/src/qhull-build/libqhullstatic.a

    INSTALL_COMMAND
        ${CMAKE_COMMAND} -E copy <BINARY_DIR>/libs/libcosmotools${lib_suffix} <INSTALL_DIR>/lib
)

# Any project that depends on cosmotools inherits the following cmake args
add_extra_cmake_args(
    -DCOSMOTOOLS_INCLUDE_DIR:PATH=${SuperBuild_BINARY_DIR}/cosmotools/src/cosmotools-build/include
    -DCOSMOTOOLS_LIBRARIES:PATH=${SuperBuild_BINARY_DIR}/cosmotools/src/cosmotools-build/libs/libcosmotools${lib_suffix}
)

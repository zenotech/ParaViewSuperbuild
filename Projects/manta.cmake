add_external_project(
  manta
  DEPENDS libxml2 zlib
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DMANTA_ENABLE_X11:BOOL=OFF
    -DSCENE_0:BOOL=OFF
    -DSCENE_AREA_LIGHT:BOOL=OFF
    -DSCENE_BEACH:BOOL=OFF
    -DSCENE_COMPLEXITYTEST:BOOL=OFF
    -DSCENE_CUBE_WORLD:BOOL=OFF
    -DSCENE_EXTERNAL_OBJECT:BOOL=OFF
    -DSCENE_FENCE:BOOL=OFF
    -DSCENE_GALILEO:BOOL=OFF
    -DSCENE_GRIDISOVOL:BOOL=OFF
    -DSCENE_HDRI:BOOL=OFF
    -DSCENE_MACBETH:BOOL=OFF
    -DSCENE_OCTISOVOL:BOOL=OFF
    -DSCENE_PRIMTEST:BOOL=OFF
    -DSCENE_SOFT_SHADOW:BOOL=OFF
    -DSCENE_TEAPOT_ROOM:BOOL=OFF
    -DSCENE_TRIANGLESCENEVIEWER:BOOL=OFF
    -DSCENE_TYLENOL:BOOL=OFF
    -DSCENE_VALUE_COLORMAP:BOOL=OFF
    -DSCENE_VORPAL:BOOL=OFF

    # turn off SSE on 32-bit builds.
    -DMANTA_SSE:BOOL=${64bit_build}
  INSTALL_COMMAND
    ${CMAKE_COMMAND} -E copy_directory <BINARY_DIR>/lib <INSTALL_DIR>/lib
)

if (UNIX AND NOT APPLE)
  add_external_project_step(patch1
      COMMENT "Fixing missing include files."
      COMMAND ${CMAKE_COMMAND} -E copy_if_different
              "${SuperBuild_PROJECTS_DIR}/patches/manta.Core.Thread.Thread.cc"
              "<SOURCE_DIR>/Core/Thread/Thread.cc"
      DEPENDEES update
      DEPENDERS patch)

  add_external_project_step(patch2
      COMMENT "Fixing missing include files."
      COMMAND ${CMAKE_COMMAND} -E copy_if_different
              "${SuperBuild_PROJECTS_DIR}/patches/manta.Core.Containers.Array3.h"
              "<SOURCE_DIR>/Core/Containers/Array3.h"
      DEPENDEES update
      DEPENDERS patch)

  add_external_project_step(patch3
    COMMENT "Fixing missing target link libraries for 'dl'."
      COMMAND ${CMAKE_COMMAND} -E copy_if_different
              "${SuperBuild_PROJECTS_DIR}/patches/manta.Core.CMakeLists.txt"
              "<SOURCE_DIR>/Core/CMakeLists.txt"
      DEPENDEES update
      DEPENDERS patch)
endif()

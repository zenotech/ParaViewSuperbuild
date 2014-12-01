set (qt_depends)
set (qt_options)
set (patch_command)
if (NOT APPLE AND UNIX)
  list (APPEND qt_depends freetype fontconfig png)
  list (APPEND qt_options
               -system-libpng
               -I <INSTALL_DIR>/include/freetype2
               -I <INSTALL_DIR>/include/fontconfig)
  # Fix Qt build failure with GCC 4.1.
 set (patch_command PATCH_COMMAND
                    ${CMAKE_COMMAND} -E copy_if_different
                    ${SuperBuild_PROJECTS_DIR}/patches/qt.src.3rdparty.webkit.Source.WebKit.pri
                    <SOURCE_DIR>/src/3rdparty/webkit/Source/WebKit.pri)
elseif (APPLE)
  # Set the platform to be clang if on apple and not gcc
  # This doesn't work on 10.5 (leopard) 10.6 (snow leopard) toolchain, however.
  # So, we check for that.
  if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND
      CMAKE_OSX_DEPLOYMENT_TARGET AND
      CMAKE_OSX_DEPLOYMENT_TARGET VERSION_GREATER "10.6")
    list (APPEND qt_options -platform unsupported/macx-clang)
  endif()

  list (APPEND qt_options
              -sdk ${CMAKE_OSX_SYSROOT}
              -arch ${CMAKE_OSX_ARCHITECTURES}
              -qt-libpng)
endif()
set(qt_EXTRA_CONFIGURATION_OPTIONS ""
    CACHE STRING "Extra arguments to be passed to Qt when configuring.")

set(extra_commands)
if (CMAKE_GENERATOR STREQUAL "Ninja")
  # when using ninja, we can't use Ninja to build Qt, so we change that to
  # "make".
  set (extra_commands
        BUILD_COMMAND make
        INSTALL_COMMAND make install)
endif()
add_external_project_or_use_system(
    qt
    DEPENDS zlib ${qt_depends}
    ${patch_command}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
      -prefix <INSTALL_DIR>
      -confirm-license
      -release
      -no-audio-backend
      -no-dbus
      -no-declarative-debug
      -nomake demos
      -nomake examples
      -no-multimedia
      -no-openssl
      -no-phonon
      -no-scripttools
      -no-svg
      -no-webkit
      -no-xinerama
      -no-xvideo
      -opensource
      -qt-libjpeg
      -qt-libtiff
      -system-zlib
      -xmlpatterns
      -I <INSTALL_DIR>/include
      -L <INSTALL_DIR>/lib
      ${qt_options}
      ${qt_EXTRA_CONFIGURATION_OPTIONS}
      ${extra_commands}
)
unset(extra_commands)

if ((NOT 64bit_build) AND UNIX AND (NOT APPLE))
  # on 32-bit builds, we are incorrectly ending with QT_POINTER_SIZE chosen as
  # 8 (instead of 4) with GCC4.1 toolchain on old debians. This patch overcomes
  # that.
  add_external_project_step(qt-patch-configure
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
                              ${SuperBuild_PROJECTS_DIR}/patches/qt.configure
            <SOURCE_DIR>/configure
    DEPENDEES patch
    DEPENDERS configure)
endif()

if (APPLE)
  # corewlan .pro file needs to be patched to find
  add_external_project_step(qt-patch-corewlan
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
                              ${SuperBuild_PROJECTS_DIR}/patches/qt.src.plugins.bearer.corewlan.corewlan.pro
            <SOURCE_DIR>/src/plugins/bearer/corewlan/corewlan.pro
    DEPENDEES configure
    DEPENDERS build)
endif()

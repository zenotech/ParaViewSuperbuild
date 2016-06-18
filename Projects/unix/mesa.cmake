if(BUILD_SHARED_LIBS)
  set(shared_args --enable-shared --disable-static)
else()
  set(shared_args --disable-shared --enable-static)
endif()

add_external_project(mesa
  DEPENDS llvm
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --enable-opengl --disable-gles1 --disable-gles2
                    --disable-va --disable-gbm --disable-xvmc --disable-vdpau
                    --enable-shared-glapi
                    --disable-texture-float
                    --disable-dri --with-dri-drivers=
                    --enable-gallium-llvm
                    --enable-llvm-shared-libs       # FIXME: need to use static when llvm is static
                    --with-gallium-drivers=swrast   # FIXME: add swr when available.
                    --disable-egl --disable-gbm --with-egl-platforms=
                    --enable-glx
                    --with-llvm-prefix=${LLVM_DIR}
                    ${shared_args}
  BUILD_IN_SOURCE 1
)
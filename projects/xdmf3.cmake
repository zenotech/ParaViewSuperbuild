# Make a dummy xdmf3 project so that the user can enable or disable building
# paraview with Xdmf3 support.
superbuild_add_dummy_project(xdmf3
  DEPENDS boost)

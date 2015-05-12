![ParaView-Superbuild](Documentation/img/paraview100.png)

Introduction
============
ParaView-Superbuild is a project to build ParaView. ParaView itself can be
easily built using CMake. However, ParaView has several external dependencies,
e.g. Qt, CGNS, FFMPEG, etc. and it can be very tedious to build all those
dependencies. Also, if you want to generate redistributable binaries, you need to
take extra case building and packaging these dependencies. To make our lives
easier in supporting both these use-cases, ParaView-Superbuild project was born.

Although primarily designed to build the official ParaView binaries,
ParaView-Superbuild has since been regularly used to build ParaView packages
on various supercomputing systems.

Learning Resources
==================

* General information is available at the [ParaView Homepage][].

* Community discussion takes place on the [ParaView Mailing Lists][].

* Commercial [support][Kitware Support] and [training][Kitware Training]
  are available from [Kitware][].

[ParaView Homepage]: http://www.paraview.org
[ParaView Mailing Lists]: http://www.paraview.org/mailing-lists/
[Kitware]: http://www.kitware.com/
[Kitware Support]: http://www.kitware.com/products/support.html
[Kitware Training]: http://www.kitware.com/products/protraining.php

Reporting Bugs
==============

If you have found a bug:

1. If you have a patch, please read the [CONTRIBUTING.md][] document.

2. Otherwise, please join the one of the [ParaView Mailing Lists][] and ask
   about the expected and observed behaviors to determine if it is
   really a bug.

3. Finally, if the issue is not resolved by the above steps, open
   an entry in the [ParaView Issue Tracker][].

[ParaView Issue Tracker]: http://www.paraview.org/Bug

License
=======

Like ParaView, ParaView-Superbuild is distributed under the OSI-approved BSD 3-clause License.
See [Copyright.txt][] for details. For additional licenses, refer to
[ParaView Licenses][].

[Copyright.txt]: Copyright.txt
[ParaView Licenses]: http://www.paraview.org/paraview-license/

Contributing
============

See [CONTRIBUTING.md][] for instructions to contribute.

[CONTRIBUTING.md]: CONTRIBUTING.md

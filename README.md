Plasma Simple Shell
===================

This is the shell for Maui.

It contains a Qt platform theme plugin, shells for different form
factors such as desktop, netbook and tablet and QML plugins.

Only the desktop shell is implemented at the moment though.

## Dependencies

In order to build and install Plasma Simple Shell you need Qt 5.2 or better with
at least the following modules:

* qtbase
* qtdeclarative
* qtscript

## Build

Building this module is a piece of cake.

Assuming you are in the source directory, just create a build directory
and run cmake:

```sh
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/pss ..
```

To do a debug build the last command can be:

```sh
cmake -DCMAKE_INSTALL_PREFIX=/opt/pss -DCMAKE_BUILD_TYPE=Debug ..
```

To do a release build instead it can be:

```sh
cmake -DCMAKE_INSTALL_PREFIX=/opt/pss -DCMAKE_BUILD_TYPE=Release ..
```

If not passed, the `CMAKE_INSTALL_PREFIX` parameter defaults to /usr/local.
You have to specify a path that fits your needs, /opt/pss is just an example.

Package maintainers would pass `-DCMAKE_INSTALL_PREFIX=/usr`.

The `CMAKE_BUILD_TYPE` parameter allows the following values:

* **Debug:** debug build
* **Release:** release build
* **RelWithDebInfo:** release build with debugging information

## Installation

It's really easy, it's just a matter of typing:

```sh
make install
```

from the build directory.

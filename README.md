# Auto-CMake 
My Cmake based build system. 

This is my personnal build system that I wrote and tested quickely, and some features not used nor tested may be broken. It does the work for me.

# Goal
Facilitate start of C projects by exposing cmake functionnalities by file system interface

# Collateral Features
Provide Monkey patching in tests (Just define function with same name)
Reduce executable size (By intensive use of libraries)
Add test targets (Memory check, build only tests...)
Separate the test build from the normal one

# Usage
Clone the repo, read this doc, replace/removes existing files. (Dont forget to empty build-helper/configure/root)

The interface is mainely file system based. Thoses interaction will be explained. The other things you may want to touch are concentred in the main Cmake in a delimited zone

The extern folder is supposed to contain externals projects. The one in test will only be accessible for tests. The ones in lib are not automatically added in the source, and you need to recolt the lib you need by manually seting it up in the cmake 


## Instalable software
Any \*.c files in code/entry are interpreted as entry point module, and should define main functions. The headers and sources in both extern/normal/src and code/src will be accessibles, as the lirary from the systems specified by the variable LIB\_FROM\_SYSTEM

The libraries that you manually CMake-setted-up and recolted to the exposed function (see example) in extern/normal/lib will also be linked against.

## Tests
Any \*.c files in test/entry are interpreted as an entry point module, and will be integred in the test suit. The previously mentioned libraries and sources are accessible. Moreover, you can use there any code in test/src, extern/test/src. The LIB\_FROM\_SYSTEM\_TEST and extern/test/lib function in the same way

The test are executed in the /test/data dir. Functions redefinied in test overide the ones from the normal build

## Configuration
The cmake configuration feature can be used trought the build-helper/configure/root mirror. Any "To be configured by CMake" will be configured in the mirrored path relative to the CMake source dir.


# Got you
You need to manage the targets dependencies that cannot be inferred magically. For exemple if a test execute another test, you should add in one of the test cmake the good add\_dependencies calls

You need to prevent some name collisions. Every entry point should have a different name

# Not tested
The project is not tested as much as it should, because it is particulary annoying to set up entires C tests projects. 

## Needed
I had the need once to compile an executable that would be used by the tests but that should not be used directly in the test suit. So that's were you put those. They can access the same code base as the regular test ones

## Install lib
The normal project can be instalable as a library, if you set one of the variables to the name of the resulting library:
INSTALL\_SOURCES\_AS\_STATIC\_LIB 
INSTALL\_SOURCES\_AS\_SHARED\_LIB 

# TODO
Replace macros by function + set parent scope
Finish the test target so it run modified/previously failed tests only
Integrate every usefull I will encounter the need for at some points (usefull code definition)




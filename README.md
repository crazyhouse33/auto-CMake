# Auto-CMake 
My Cmake based build system. 

I wrote and tested quickely, and some features not used nor tested may be broken. I share this as it is, and I wont cleanely maintain different branchs.

# Goal
Facilitate start of C projects by exposing cmake functionnalities in file system interface. 

# Features
File system interface:
1. Provide tests suit (with monkeypatching support) 
1. Provide executable instalable target
1. Provide CMake file configuration step 
2. Remove the need to list your source files

Auto-CMake try to reducethe end executable size. The backend use intensively libraries linking for this purpose (Removing useless code from exe) and separate the test code space from the non test one.

Additionally, this project expose others features tweakable in the main cmakelist, such as:
1. Git branch detection
2. Instalable library creation

It also create usefull targets (Memory test, build only tests...)

# Usage
Clone the repo, read this doc, replace/removes the existings files (used for my tests).  

The interface is mainely file system based. Thoses interaction will be explained. The others things you may want to touch when you change project are variables concentred in the main CMake in a delimited and documented zone.


## The extern folder
The extern folder is suposed to contain externals projects. The files in test will only be accessible for tests. The ones in lib are not automatically added in the source, and you need to collect the libs you need by manually creating them in the cmakelist.


## Instalable executable ##
Any \*.c files in code/entry are interpreted as entry point module, and should define main functions. The compiled executable will be an instalable target. The headers and sources in both extern/normal/src and code/src will be accessibles, as the lirary from the systems specified by the variable LIB\_FROM\_SYSTEM.

The libraries that you manually CMake-setted-up and recolted to the exposed function (see example) in extern/normal/lib will also be linked against.

## Tests
Any \*.c files in test/entry are interpreted as an entry point module, and will be integred in the test suit. The previously mentioned libraries and sources are accessible. Moreover, you can use there any code in test/src, extern/test/src. The LIB\_FROM\_SYSTEM\_TEST and extern/test/lib libs in the same way

The test are executed in the /test/data dir. Functions redefinied in test overide the ones from the normal build

If the name of the test finish by \_WF, the test must exit a non 0 statut in order to pass.

## Configuration
The cmake configuration feature can be used trought the build-helper/configure/root mirror. Any "To be configured by CMake" will be configured in the mirrored path relative to the CMake source dir.


# Got you
1. You need to manage the targets dependencies that cannot be inferred magically. For exemple if a test execute another test, you should add in one of the test cmake the good add\_dependencies calls

2. You need to prevent some name collisions. Every entry point should have a different name

# Not tested
The project is not tested as well as it should, because it is particulary annoying to set up entires dummy C projects to test features independently. 

## Needed
The repertory work like the normal test entry. However, the resulted executable wont be run in a test-suit. This is needed when you need to compile an executable for one of your test to run on. **Dont forget to add the dependency**
## Install lib
The normal project can be instalable as a library, if you set one of the variables to the name of the resulting library:
1. INSTALL\_SOURCES\_AS\_STATIC\_LIB 
1. INSTALL\_SOURCES\_AS\_SHARED\_LIB 

## dev
The dev folder contain my githook based local continious integration tool. If you share the hooks with the script in .git-hooks, the scripts will be firing at specified events.

# TODO
1. Replace macros by function + set parent scope
1. Finish the test target so it run modified/previously failed tests only
1. Separate an empty skeletons from the tests projects
1. Add more package to lib conventions
1. Add more usefull stuff





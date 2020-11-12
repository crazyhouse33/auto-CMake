# Auto-CMake 
My Cmake based build system. 

I wrote and tested quickely, and some features not used nor tested may be broken. I share this as it is, and I wont maintain a clean git.

# Goal
Facilitate start of C projects by exposing cmake functionnalities in a file system interface. Reduce the CMake interaction needed (for exemple no listing of source files). Offer flexibility to create complex code suits

# Features
This project provide out of the box, via a file system interface:
1. Test suit (with monkeypatching support) 
2. Perf suit
4. Automatically create instalable executables 
1. Expose CMake file configuration step 

This project expose others features tweakable in the main CMakeList, such as:
1. Git branch detection
2. Instalable library creation


Moreover, this cmake expose a cmake api in order to create more "suits" (called ring) (via the rings functions)


# Usage
Clone the repo, read this doc, replace/removes the existings files (used for my tests).  

# Organisation

## Rings
The project create differents code space:  perf, test, code

Each space can access the code/libs of the outter one, thus creating some kind of code ring.

Each space can redefine a function of an outter space.

Each ring is organized the same way.

### Entry

The C entry point modules inside correspond to executables that are interpreted differently according to the ring. The executables end up in the bin/ring directory

### Src
The src folder contains the sources accessible from all the entries.

### Extern project 
Each extern project will be in the root extern directory, and the path will decide how and to which ring it will be added:
1. Source inclusion: extern/space/src: This will add the project to the ring 
2. Lib creation: extern/space/lib: Nothing will be done there. You have to manually create a library in the CMakelist, and add it to be linked against (see exemple in normal/lib CMakelist).

For each ring, you can also ask for a system library, via the LIB\_FROM\_SYSTEM\_RING variable.


## Entry type
### Code ###
Any \*.c files in code/entry are interpreted as instalable executable. 

### Test ###
Any \*.c files in test/entry are interpreted as a test to be integrated in the test suit. 

The test are executed in the /test/data dir. 
 
If the name of the test finish by \_WF, the test must exit a non 0 statut in order to pass.

The project define for you some targets (mem-test, build-test). The other ones are currently bugged

Auto-cmake comes with a default test framework (munit)

### Perf ###
Any \*.c files in perf/entry are interpreted as a perfomance collecter. 

The perf executables are run in /perf/data.

Some targets are added to create graphs.

Auto-cmake comes with my default block-profiling framework, but it try to get it in the system. You can either install it(https://github.com/crazyhouse33/eprof), or use another one.


## Configuration
The cmake configuration feature can be used trought the build-helper/configure/root mirror. Any "To be configured by CMake" will be configured in the mirrored path relative to the CMake source dir.

# Not tested
The project is not tested as well as it should, because it is particulary annoying to set up entires dummy C projects to test features independently. 

## Needed
The repertory work like the normal test entry. However, the resulted executable wont be run in a test-suit. This is needed when you need to compile an executable for one of your test to run on. **Dont forget to add the dependency**

## Install lib
The code ring can be instalable as a library, if you set one of the variables to the name of the resulting library:
1. INSTALL\_SOURCES\_AS\_STATIC\_LIB 
1. INSTALL\_SOURCES\_AS\_SHARED\_LIB 

## Cutting rings
You can add a new ring that wont access the previous ones. See the set\_rings in build-helper/rings.cmake

## dev
The dev folder contain my githook based local continious integration tool. If you share the hooks with the script in .git-hooks, the scripts will be firing at specified events.

# Got you
2. You need to prevent CMake targets name collision. This mean for exemple that entries should have a different names, even across rings


# TODO
1. Replace macros by function + set parent scope
1. Finish the test target so it run modified/previously failed tests only
1. Separate an empty skeletons from the tests projects
1. Add more package to lib conventions
1. Add more usefull stuff






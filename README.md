# Auto-CMake 
My Cmake based build system. 

I share this as it is (Maybe broken), and I wont maintain a clean git.

# Goal
Facilitate start of C projects by exposing most of cmake functionnalities in a file system interface and a central conf file. 

# Features
This project provides out of the box:
1. Incremental Test suit (with monkeypatching support) 
2. Incremental Perf suit (with monkeypatching support)
1. Easy configuration steps(In the CMake sens) 
3. Easy exportation of your sources into separated tweakable libraries
2. Easy external project inclusion (by source, system, or manually compiled library)


Moreover, this cmake expose a cmake api in order to create more "suits" (called ring), and other usefull functions that you may use.

# Usage
Clone the repo, read this doc, put your sources where there belong to achieve the build you want. Take a look at exemples in this repo (used for my tests). 

Then, run use CMake/the chosen generator the normal way from the build directory.

# Organisation

## Rings
The project create differents code space:  perf, test, code

Each space can access the code/libs of the outter one, thus creating some kind of ring.

Each ring can redefine a function of an outter ring.

Each ring is organized the same way:

### Entry

The C entry point modules inside correspond to executables that are interpreted differently according to the ring. 

### Src
The src folder contains the inner sources accessible from the entries of the current and outter ring.

Each directory in this folder is going to be represent a library that you can independently configure (static/shared, install or not...) in the conf file. 

### Extern project 
Each ring can use external project sources, and the consecutive folder will decide how it will be added:
1. Source inclusion: extern/src: This will add the project sources to the ring the same way it work with the regular src folder. In particular you will be able to control each libraries created by each folder in the conf file(Install lib, static or shared inclusion...).  
2. Lib creation: extern/lib: Nothing magical is done there. This is here to allow you to manually set up libraries to link to from an extern project with the standar CMake process. Use the provided function to indicate which libs the ring will use. (see exemple in code/extern/lib CMakelist).

### Conf file
In auto-cmake.conf you will find a cmake file containing all the variables necessary to interact with autocmake. 

The majority of these variables works with modifiables default for each rings that you can change, and you can specify exceptions. For exemple:

1. **The variable INSTALL\_LIB\_MODE** control the default mode of installation for all rings
2. **INSTALL\_LIB\_MODE\_code** is the default for the code ring
3. **INSTALL\_LIB\_MODE\_code\_lib1** control the the mode for the particular folder lib1 in code/src.

The files aim to give a good amount of flexibility and allow for a lot of things. For exemple, you can decide to install or not some part of your code with a different mode than the way it will be included in your entries. See the exemple to see what you can set.

This file contain also some more important variables that will lickely need changes across project. For exemple rings will be able linked to libs from the system via **LIB\_FROM\_SYSTEM\_code**.

## Entry type
### Code ###
Any \*.c files in code/entry are interpreted as executables. 

### Test ###
Any \*.c files in test/entry are interpreted as a test to be integrated in the test suit. 

The test are executed in the /test/data dir. 
 
If the name of the test finish by \_WF, the test must exit a non 0 statut in order to pass (a abort call or a crash will still result in failing test. This is a CTest limitation)

Auto-cmake comes with a default source included test framework (https://nemequ.github.io/munit/)


The project define for you some handy targets:
1. build-tests: Build all tests
2. lazy-test: Test failing and outdated tests( rebuild them before).
2. lazy-mem-test: Test with memcheck failing and outdated tests. A passing test in the regular lazy-test is not passing for the lazy-mem-test.
3. full-test: Force reconfiguration, recompilation of all, and run all tests with memcheck even if previously passed.
4. test (Default of CMake): Dont recompile anything and run all tests.


Limitation: 
1. test target wont impact the lazy-targets (If a test pass with the test target, it will be re-run by the lazy target)
1. The lazy-(mem)-test always trigger the first test of the test suit using the make Generator. The bug is not present on the Ninja Generator. This seem to be a bug of CMake


### Perf ###
Any \*.c files in perf/entry are interpreted as a perfomance collecter. 

The perf executables are run in /perf/data.

AutoCMake provides targets pulling out kvhf files (https://github.com/crazyhouse33/kvhf), from which you can extract the graphs you want.

The mains targets are :
1. perf-aggregate: Recompile and run out-dated perfs entries. Collect size of configured targets (In the associated variable in the main's CMakeList)
3. perf-save-resume: Check that the aggregation result is properly formated, and if so accumulate it in the history
 

Auto-cmake comes with my default block-profiling framework. It get it from the system (I did not include it in source because you need a python executable anyway). You can either install it (https://github.com/crazyhouse33/eprof) or use another one. In the latter case you need to modify the perf/entry CMakeList properly so the perfs-targets works.

## Configuration
The cmake configuration feature can be used trought the auto-cmake.conf/configure/ folder. Any "file to be configured by CMake" will be configured in the mirored path relative to the CMake source dir when you run CMake.

# Not tested
The project is not tested as well as it should, because it is particulary annoying to set up entires dummy C projects to test features independently, or proper dependencies.. 

## Install lib/ring
The rings can be instalable as libraries. Any sub lib of the internal source of a ring can also be instaled separatly. Check conf file (INSTALL\_LIB\_MODE)

## Install entry
Any entry can be instalable. See in conf( INSTALL\_ENTRY) 
## Static or Shared Modes
Code in each rings can be statically or dynamically linked in entries. The given conf file (INTERNAL\_LIB\_MODE) to see how it work.

## Cutting rings
You can add a new ring that wont access the previous ones. See the set\_rings in .auto-cmake/rings.cmake

## Lazy targets
The lazy targets (test and perf generation) incrementality is not tested. 

## dev
The dev folder contain my githook based local continious integration tool. If you share the hooks with the script in .git-hooks, the scripts will be firing at specified events.

# Got you
2. AutoCMake try to prevent you from running into name collision (libraries, targets...). But you may still run into them. For exemple if you use the default prefix setting and if you name a code entry test. Those colisions can be hard to understand, be aware. If you dont want to change a file system name, use RENAME\_LIB/ENTRY variable  (see conf). 

3. The level of granularity of dependencie is terrible. Thus greatly reducing the use of the lazy-test/ perf targets. If you are aware of a way to improve this, I am really interested. For long tests/perf recolts, you are free to compile an entry point as you want. If you name the target as the ring system would, the entry point will be latter ignored by the ring system.  


# TODO
1. Replace macros by function + set parent scope
1. Finish the test target so it run modified/previously failed tests only
1. Separate an empty skeletons from the tests projects
1. Add more package to lib conventions
1. Add more usefull stuff






# Auto-CMake 
My Cmake based build system. 

I wrote and tested quickely, and some features not used nor tested may be broken. I share this as it is, and I wont maintain a clean git.

# Goal
Facilitate start of C projects by exposing cmake functionnalities in a file system interface. Reduce the CMake interaction needed (for exemple no listing of source files). Offer flexibility to create complex code suits

# Features
This project provide out of the box, via a file system interface:
1. Test suit (with monkeypatching support) 
2. Perf suit (with monkeypatching support)
4. Automatically create instalable executables 
1. Expose CMake file configuration step 

This project expose others features tweakable in the main CMakeList, such as:
1. Default Built-type per branch
2. Instalable library creation


Moreover, this cmake expose a cmake api in order to create more "suits" (called ring) 

  


# Usage
Clone the repo, read this doc, replace/removes the existings files (used for my tests).  

# Organisation

Auto cmake separate your code into rings. Each rings work the same, but in a normal project, you basically only touch the code one.

## Rings
The project create differents code space:  perf, test, code

Each space can access the code/libs of the outter one, thus creating some kind of code ring.

Each ring can redefine a function of an outter ring.

Each ring is organized the same way:

### Entry

The C entry point modules inside correspond to executables that are interpreted differently according to the ring. The executables end up in the bin/ring directory

### Src
The src folder contains the sources accessible from the entries.

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
 
If the name of the test finish by \_WF, the test must exit a non 0 statut in order to pass (a abort call or a crash will still result in failing test. This is a CTest limitation)

Auto-cmake comes with a default source included test framework (https://nemequ.github.io/munit/)


The project define for you some handy targets:
1. build-tests: Build all tests
2. lazy-test: Test failing and outdated tests(it rebuild them before).
2. lazy-mem-test: Test with memcheck failing and outdated tests. A passing test in the regular lazy-test is not passing for the lazy-mem-test.

3. full-test: Force reconfiguration, recompilation of all, and run all tests with memcheck even if previously passed
4. test (Default of CMake): Dont recompile anything and run all tests.


Limitation: 
1. test target wont impact the lazy-targets (If a test pass with the test target, it will be re-run by the lazy target)
1. The lazy-(mem)-test always trigger the first test of the test suit using the make Generator. The bug is not apparent on the Ninja Generator. This seem to be a bug of CMake


### Perf ###
Any \*.c files in perf/entry are interpreted as a perfomance collecter. 

The perf executables are run in /perf/data.

Automake provide target pulling out kvhf files (https://github.com/crazyhouse33/kvhf), from which you can extract the graphs you want.

The mains targets are :
1. perf-aggregate: Recompile and run out-dated perfs entries. Collect size of configured targets (In the associated variable in the main's CMakeList)
3. perf-save-resume: Check that the aggregation result is properly formated, and if so accumulate it in the history
 

Auto-cmake comes with my default block-profiling framework, but it try to get it from the system (I did not include it in source because you need a python executable anyway). You can either install it (https://github.com/crazyhouse33/eprof), or use another one. In the latter case you need to modify the perf/entry CMakeList properly so the perfs-targets works.

## Configuration
The cmake configuration feature can be used trought the build-helper/configure/root mirror. Any "file to be configured by CMake" will be configured in the mirrored path relative to the CMake source dir.

# Not tested
The project is not tested as well as it should, because it is particulary annoying to set up entires dummy C projects to test features independently, or proper dependencies.. 

## Needed
The repertory work like the normal test entry. However, the resulted executable wont be run in a test-suit. This is needed when you need to compile an executable for one of your test to run on. **Dont forget to add the dependency**

## Install lib
The rings can be instalable as libraries, if you set the variables to the name of the resulting library:
1. "INSTALL\_LIB\_code toto" to install the code ring as the toto library 

## Static or Shared Rings
Code in rings can be statically or dynamcally included in entries. Set the INTERNAL\_LIBS\_MODE\_test STATIC/SHARED to control the test ring for example.

## Cutting rings
You can add a new ring that wont access the previous ones. See the set\_rings in build-helper/rings.cmake

## Lazy targets
The lazy targets(test and perf generation) are not tested. 

## dev
The dev folder contain my githook based local continious integration tool. If you share the hooks with the script in .git-hooks, the scripts will be firing at specified events.

# Got you
2. You need to prevent CMake targets name collision. This mean for exemple that entries should have a different names, even across rings, but also that you cant use allready automatically defined targets. In particular, dont name an entry test.c, or you will run into really wierd bugs.

3. The level of granularity of dependencie is terrible. Thus greatly reducing the use of the lazy-test/ perf targets. If you are aware of a way to improve this, I am really interested. For really long tests/perf recolts, you are free to compile an entry point as you want. If you name the target as the ring system would, the entry point will be latter ignored by the ring system.  


# TODO
1. Replace macros by function + set parent scope
1. Finish the test target so it run modified/previously failed tests only
1. Separate an empty skeletons from the tests projects
1. Add more package to lib conventions
1. Add more usefull stuff






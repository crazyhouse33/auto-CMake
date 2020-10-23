# Authbreak 
Generic authentification system injection point based tester for Linux.


# Function and motivation
Authbreak is a tool built to execute attacks that can work on every system, with the same simple and powerful user interface.

In this version, it does:

1. guessing

See the todo sections to see what's comming next



# Install

```bash
git clone --recursive https://github.com/crazyhouse33/authbreak
cd authbreak/build
cmake ..
# Add -DCMAKE_INSTALL_PREFIX:PATH=/path/to/install to the last command to install in another directory than your system default executable location (need root)
 cmake --build . target install 
```

Obvisouly you can also just build the binary which end up in the bin dir:
```bash
cmake --build . target authbreak, 
```


# Usage

The philosophy is to provide a command with some configurable injection points along with boolean combination of some target execution metrics (time, stdout...) to allow differentiation of success and failures. The different attacks backends use what you specified to generate their attacks in the most efficient way they can. They are run in order of efficiency, and can back off if they detetect there method is not working, until it falls down to brutforce. 

authbreak -h for a complete explanation of how this version works.

# Effort
## Perf
The tool had been written in C to allow for low level optimization. The build system keep tracks of perfs at every commits to detect regressions using kvhf on a local branch


# Coming

The next upcoming versions will focus on improving the guessing phase and the interface. Notally, I want to integrate the two following classifiers:
1. The target process got a prompt
2. Regexp against output


I want the user to be able to control the equilibrium between speed and furtivity when there is a trade off (should the attacks generate some kind of random padding if they are only intersted into the tail?...).  In this logic I want to implement another cartesian product for the guessing that will be really harder to detect and stop.

Then I want to add following points:

1. Automatic timing attack (Direct comparision attack, Generic statistical good guess detector, radix tree enumeration, binary tree enumeration?)
2. Big and small performance improvement (use a thread to categorize the previous output and prepare the next while the current one is running, collect only metrics useful to the used classifiers, cache the loading (idk how yet) of the targeted process)
5. More control over what's done (pass some attacks )
6. For the file template, filter the guesses to match given charset and len
7. Make it cross platform 

# Repo

Each version of authbreak is a commit in the master branch. The version changelog is the git log of master branch. 

The dev branch contains additional continuous integration files, and has a usual git messy history :)


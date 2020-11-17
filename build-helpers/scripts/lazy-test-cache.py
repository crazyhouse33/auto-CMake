#!/usr/bin/python3

# This python script expect a list of lazy and mandatory executable as argument. Then it try to rebuild the associated target. If the executable changed, it run it. If the test was reported as fail in previous session, it run it as well

import sys
import os.path
import re
import subprocess
import argparse

print (sys.argv)



parser = argparse.ArgumentParser(description="""Run a lazy test session. Your build must create 2 files for this script to work, and never modificate them again:
        1: ${CMAKE_BINARY_DIR}/ts-since-lazy-test) # file created last lazy or full test lunch
        2: ${CMAKE_BINARY_DIR}/ts-since-full-test) file created at full test 
        """)

parser.add_argument('--ctest-string','-o', help='Options to transmit to Ctest, ex: "--build-and-test --generator \"Unix Makefile\"", dont forget to quote!', default="")
parser.add_argument('--mandatory','-m', nargs='*', help="List of mandatory test in form: \"TARGET PATH\". Target is the name of the build target, path is the executable test")
parser.add_argument('--lazy','-l', nargs='*', help="List of lazy test, same form as mandatory")
parser.add_argument('--ctestPath','-p', default="ctest",help="The path of ctest on the platform, default is \"ctest\"")
parser.add_argument('--cmakePath','-P', default="cmake",help="The path of cmake on the platform, default is \"cmake\"")

parser.add_argument('--no-build', action='store_true',help="Dont rebuild tests")

args= parser.parse_args()

def runTarget(target):
    print ("Running Target: " +target)
    subprocess.call([args.cmakePath, "--build", ".", "--target", target])


def fullTestAllreadyRan():
    return os.path.isfile("ts-since-full-test")

def run(toRun):
    """Run a list of target with cmake and given options"""
    ctestSelect= "(" + "|".join(toRun) +')'
    
    print ("Test command: "+ args.ctestPath +' -R '+ ctestSelect)
    subprocess.call ([args.ctestPath, '-R', ctestSelect])

def failedPastTest(target):
    """Parse ctest report to see if is in the failed file (figthing against cmake once again) """
    with open("Testing/Temporary/LastTestsFailed.log") as f:
        wholeFile= f.read()
    return re.search(r'^\d:'+ target+'\S*$', wholeFile)


def isToRun(target, executable):
    """ Executable is to be retested if he is younger than last test, or if he failed last test"""
    return failedPastTest(target) or os.path.getmtime(executable) < lastTest


if not args.no_build:
    runTarget("build-tests")

#TODO make test create a dependencie
if not fullTestAllreadyRan():
    print ("\nThe full test have never been run!\n")
    runTarget('all-test')
    exit(0)

lastTest= os.path.getmtime("ts-since-lazy-test")


toRun= [ mandatory[0] for mandatory in args.mandatory ]

for target in args.lazy:
    target, execPath= target.split(' ',1)
    if isToRun(target, execPath):
        toRun.append(target)

run(toRun)



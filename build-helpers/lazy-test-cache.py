#!/usr/bin/python3

# This python script expect a list of lazy and mandatory executable as argument. Then it try to rebuild the associated target. If the executable changed, it run it. I fought CMake A LOT to try to get a full CMake solution. But it always had drawbacks https://discourse.cmake.org/t/why-fixtures-are-forced-to-be-tests/2194/6. If I do unrelated targets calling CTest, I must call ctest on all of them one by one, which could have drawback if I start using the dashboard features and other stup

import sys
import os.path
from pathlib import Path
import re
import subprocess
import argparse

print (sys.argv)



parser = argparse.ArgumentParser(description="""Run a lazy test session. Your build must create 2 files for this script to work, and never modificate them again:
        1: ${CMAKE_BINARY_DIR}/ts-since-lazy-test) # file created last lazy or full test lunch
        2: ${CMAKE_BINARY_DIR}/ts-since-full-test) file created at full test 
        """)

parser.add_argument('--ctest-string','-o', help='Options to transmit to Ctest, ex: "--build-and-test --generator \"Unix Makefile\"", dont forget to quote!', default="")
parser.add_argument('--lazy','-l', nargs='*', help="List of lazy test, same form as mandatory")
parser.add_argument('--ctestPath','-p', default="ctest",help="The path of ctest on the platform, default is \"ctest\"")
parser.add_argument('--cmakePath','-P', default="cmake",help="The path of cmake on the platform, default is \"cmake\"")

parser.add_argument('--no-build', action='store_true',help="Dont rebuild tests")

args= parser.parse_args()

def runTarget(target):
    print ("Building Target: " +target)
    subprocess.call([args.cmakePath, "--build", ".", "--target", target])


def run(toRun, options):
    """Run a list of test with and given options"""
    ctestSelect= "(" + "|".join(toRun) +')'
    
    print ("Test command: "+ args.ctestPath +' -R '+ ctestSelect + " " + options)
    subprocess.call ([args.ctestPath, '-R', ctestSelect, options])

def last_test_failed():
    """Parse ctest report to return the target that failed last time run """
    with open("Testing/Temporary/LastTestsFailed.log") as f:
        wholeFile= f.read()
    return re.search(r'^\d:(.*)\S*$', wholeFile).groups


def isToRun(target, executable):
    """ Executable is to be retested if he is younger than last test, or if he failed last test"""
    return failedPastTest(target) or os.path.getmtime(executable) < lastTest

def get_success_file(target):
    return target+"_succeed.marker"

def mark_sucess(target):
    """Mark a target as succeed"""
    Path(get_success_file(target)).touch()

def is_marked(target):
    return os.path.isfile(get_success_file(target))

def get_outdated(target_list, executable_list, executable_old_dates):
    """Return out_dated targets, according to path of associed executable and old dates"""
    out_dated=[]
    lazy_exe_date=[os.path.getmtime(path) for path in lazy_exe]
    for i, executable in enumerate(target_list):
        if os.path.getmtime(executable) > lazy_exe_date[i]: #Outdated
            out_dated+= lazy_targets[i]
    return out_dated

def deal_with_targets(target_list):
    """Lazy test a group of targets"""
    # Getting the one that did not pass yet
    target_list = [ target for target in target_list if tar

    # Running the tests
    run(target_list)

    # Marking the ones passing
    passing = [ target for target in target_list if target not in last_test_failed()]
    for target in passing:
        mark_sucess(target)


lazy_targets=[x[0] for x in args.lazy]
lazy_exe= [x[1] for x in args.lazy]

lazy_exe_date=[os.path.getmtime(path) for path in lazy_exe]


if not args.no_build:
    for target in lazy_targets:
        runTarget(target)


out_dateds = get_outdated(lazy_targets, lazy_exe, lazy_exe_date)
for target in out_dateds:
    os.remove(get_success_file(target))





#!/usr/bin/python3

# This is the result of a long fight with CMake to get a target that allow to run only the necessary tests. This operate with CMke by creating some files on succeed. The CMkae build create some dependencies on theses files running this script. The script filter the tests that allready passed. I tried a lot to get a pure CMake/python solution but it always had drawbacks (Fixture: CMake force it to be tests, wich add a crazy amount of junk in the report. Full python, there is no api to check if a target is uptodate, so I would need a way to list all the depends files in CMake and give it to python. )

import sys
import os.path
from pathlib import Path
import re
import subprocess
import argparse
import shlex


parser = argparse.ArgumentParser(description="""Run a list of tests with given ctest options, mark them as suceed 
k       """)

parser.add_argument('--ctest-options','-o',default="", help='Options to transmit to Ctest, ex: "--build-and-test --generator \"Unix Makefile\"", dont forget to quote!')
parser.add_argument('tests', nargs='+', help="List of tests to run")
parser.add_argument('--ctestPath','-p', default="ctest",help="The absolute path of ctest on the platform")
parser.add_argument('--marks-dirs','-d', action="append",required=True,help="A list of paths to succeed marks directories. The target is marked if in the first path. Every subsequent path will be writed at marked on success")
parser.add_argument('--verbose','-v', action="store_true",help="verbose mode")

args= parser.parse_args()


def my_print(*funcargs, **kwargs):
    if args.verbose:
        print (*funcargs, **kwargs)


def run(toRun, options):
    """Run a list of test with and given options"""

    toRun = [ "^"+x+"$" for x in toRun]
    ctestSelect= "(" + "|".join(toRun) +')'
    
    sub_argv=[args.ctestPath, '-R', ctestSelect] + shlex.split(options) 
    my_print ("Test command:", *sub_argv)
    return subprocess.call (sub_argv)

def last_test_passing(last_runned,ret):
    """Parse ctest report to return the target that passed last time run. Ret is the Ctest exit code. last_runned are the last runned tests. Thoses are needed to interpret correctly """
    # See https://stackoverflow.com/questions/39945858/cmake-testing-causing-error-when-tests-fail
#enum {
#  UPDATE_ERRORS    = 0x01,
#  CONFIGURE_ERRORS = 0x02,
#  BUILD_ERRORS     = 0x04,
#  TEST_ERRORS      = 0x08,
#  MEMORY_ERRORS    = 0x10,
#  COVERAGE_ERRORS  = 0x20,
#  SUBMIT_ERRORS    = 0x40
#};
    if not(ret==0 or ret & 0x08 or ret & 0x10 or ret & 0x20 or ret & 0x40):# We try to also handle the case where CTest does not respect the enum and crash or whatever)
        my_print("Lazy test wont mark any target because of this ctest exit status:",ret)
        return [] # Nothing could have passed.

    try:
        with open("Testing/Temporary/LastTestsFailed.log") as f:
            wholeFile= f.read()
        failing = re.findall(r'^\d:(.*)\S*$', wholeFile)
    except FileNotFoundError:# Ninja dont generate if no fail
        failing=[]

    return [ x for x in last_runned if x not in failing]


def get_success_files(target):
    for mark in args.marks_dirs:
        yield mark+'/'+target+"_succeed.marker"

def mark_sucess(target):
    """Mark a target as succeed"""
    for i, f in enumerate(get_success_files(target)):
        os.makedirs(args.marks_dirs[i],  exist_ok=True)
        Path(f).touch(exist_ok=True)

def is_marked(target):
    return os.path.isfile(next(get_success_files(target)))

def get_non_marked(test_list):
    """Return non marked test from the test_list"""
    return [ target for target in test_list if not is_marked(target)]


# Getting the one that did not pass yet
tests_to_run = get_non_marked(args.tests)

# Running the tests
ret=run(tests_to_run, args.ctest_options)

# Marking the ones passing
passing = last_test_passing( tests_to_run, ret)
for target in passing:
    mark_sucess(target)
my_print("Marking ass successfull:", *passing)








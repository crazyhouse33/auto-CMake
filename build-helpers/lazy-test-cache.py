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
parser.add_argument('--marks-dir','-d', default=".",help="The path to the directory where to put succeed marks")
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
    subprocess.call (sub_argv)

def last_test_failed():
    """Parse ctest report to return the target that failed last time run """
    try:
        with open("Testing/Temporary/LastTestsFailed.log") as f:
            wholeFile= f.read()
        return re.findall(r'^\d:(.*)\S*$', wholeFile)
    except FileNotFoundError:# Ninja dont generate if no fail
        return []

def get_success_file(target):
    return args.marks_dir+'/'+target+"_succeed.marker"

def mark_sucess(target):
    """Mark a target as succeed"""
    f=get_success_file(target)
    os.makedirs(args.marks_dir,  exist_ok=True)
    Path(f).touch( exist_ok=True)

def is_marked(target):
    return os.path.isfile(get_success_file(target))

def get_non_marked(test_list):
    """Return non marked test from the test_list"""
    return [ target for target in test_list if not is_marked(target)]


# Getting the one that did not pass yet
tests_to_run = get_non_marked(args.tests)

# Running the tests
run(tests_to_run, args.ctest_options)

# Marking the ones passing
passing = [ target for target in tests_to_run if target not in last_test_failed()]
for target in passing:
    mark_sucess(target)
my_print("Marking ass successfull:", *passing)








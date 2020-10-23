import pytest
import os

root='..'

def exec_match( command, status, working_dir, dont_match=False):
    old=os.getcwd()
    os.chdir(root+'/'+working_dir)
    print('Running: '+command)
    assert os.WEXITSTATUS(os.system(command)) == status and dont_match==False
#    assert os.path.isfile(path_out)
    os.chdir(old)

    

def cmake_configure(add_args='', expected=0, dont_match=False):
    exec_match('cmake {} ..'.format(add_args), expected, 'build', dont_match=dont_match)



def cmake_build(target, expected=0, dont_match=False):
    exec_match('cmake --build --target '+target, expected,'build', dont_match=dont_match)

working_configurations =['', '-DINTERAL_LIBS_MODE=STATIC', 

        ]

working_targets = ['all', 'mem-test']

def test_integration():

    for config in working_configurations:
        cmake_configure(config)
        cmake_build('clean')
        for target in working_targets:
            cmake_build(target)




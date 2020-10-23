#!/bin/bash
set -e
#Run test
echo building again from scratch
cd ../build
rm -rf -- *
cmake .. -G Ninja
cmake --build . --target all
cmake --build . --target test

#kvhf creation

echo aggregating perf result 
hkvf_file_dir="../bin/test_binaries/perfs/"

cmake --build . --target kvhf



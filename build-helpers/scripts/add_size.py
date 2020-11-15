#!/usr/bin/env python3
import os.path
import argparse

parser = argparse.ArgumentParser(description='Add size of a file to a kvhf file')

parser.add_argument(
    'files',
    metavar='FILE',
    nargs=2,
    help="The kvhf you want to add the size come first, the target second")

parser.add_argument(
    '--key-name',
    '-n',
    nargs=1,
    help="Name of the key")

args=parser.parse_args()

path, to_measure = args.files
if args.key_name == None:
    key_name=os.path.basename(to_measure)+"_size"
else:
    key_name= args.key_name[0]
size= os.path.getsize(to_measure)
unity='o'
print (size, unity,sep="")
cmd="kvhfutils {} -k {}:{} -k {}:unity:{}".format(path,key_name,size,key_name,unity)
os.system(cmd)


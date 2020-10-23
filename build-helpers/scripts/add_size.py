#!/usr/bin/env python3
import os.path

path='../../perfs/commit_resume.hkvf'
size= os.path.getsize(path)
unity='Ko'
print (size, unity)
cmd="kvhfutils {} -k Exe_size:{} -k Exe_size:unity:{}".format(path,size,unity)
os.system(cmd)


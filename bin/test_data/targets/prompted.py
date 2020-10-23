import sys

with open('testfile','w') as f:
    print(*sys.argv, file=f)
    print(input(), file=f)
    print(input(), file=f)
    print(input(), file=f)

print("test sdout recup")
print("test stderr recup", file=sys.stderr)

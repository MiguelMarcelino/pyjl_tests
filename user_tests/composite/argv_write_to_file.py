from os import path
import sys


if __name__ == "__main__":
    args: list[str] = sys.argv
    contents = []
    if len(args) > 1 and path.isfile(args[1]):
        with open(args[1], "r") as f:
            contents.append(f.readline())

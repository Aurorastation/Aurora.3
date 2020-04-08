import sys

version = (3, 9) # Check if python version is greater that this.

if sys.version_info < version:
    print("Sorry, this requires python >= {}. Your version is {}!".format(version, tuple(sys.version_info)))
    exit(1)
exit(0)
import sys

def check_version():
    version = (3, 4)

    if sys.version_info < version:
        print("Sorry, this requires python >= {}. Your version is {}!".format(version, tuple(sys.version_info)))
        exit()
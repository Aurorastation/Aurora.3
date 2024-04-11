import os
import sys
import re

def _self_test():

    cameras_ctags = []
    conflicting_camera_ctags = []

    for dirpath, dirnames, filenames in os.walk('.'):
        if '.git' in dirnames:
            dirnames.remove('.git')
            continue

        for filename in filenames:
            if filename.endswith('.dmm'):
                fullpath = os.path.join(dirpath, filename)

                with open(fullpath, 'r', encoding="utf-8") as file:
                    lines = file.readlines()

                    for line in lines:
                        match = re.match(r'^\t?c_tag = \"(.+)\"', line)

                        if match:
                            # print(match.group(0))
                            if match.group(1) not in cameras_ctags:
                                cameras_ctags.append(match.group(1))
                            else:
                                if match.group(1) not in conflicting_camera_ctags:
                                    conflicting_camera_ctags.append(match.group(1))


    if conflicting_camera_ctags:
        raise ValueError(f'Duplicate c_tag found in {fullpath}: {conflicting_camera_ctags}')

    else:

        print(f"The following c_tags are defined in the various DMMs: {cameras_ctags}")


def _main():
    if len(sys.argv) == 1:
        return _self_test()


if __name__ == '__main__':
    _main()

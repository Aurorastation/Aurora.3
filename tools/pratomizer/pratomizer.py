"""This tool is used to atomize the PRs, it makes a new branch from master, copy the files
that constitute the atomic change and commit them with a specified message.

It also prepare a changelog file for you to edit, with format gitusername-prname, and
sets the author inside it with your username.

Remember to install the requirements on your system, if not already installed:
pip install -r requirements.txt

Released under GNU Affero General Public License <https://www.gnu.org/licenses/agpl-3.0.en.html>
"""

import os
import re
import click
from git import Repo
from git import SymbolicReference


@click.command()
@click.option('--file', '-f', required=True, help='The file relative path, or comma \
  separated list of files to atomize for the new PR')
@click.option('--prname', '-p', required=True, help='The name of the PR/Branch you want the tool to create')
@click.option('--nocommit', is_flag=True, help='If this flag is specified, do not commit the changes.')
@click.option('--commitmessage', '-c', default='Atomization', help='The commit message to use for\
  the commit, otherwise, "Atomization" will be used')
@click.option('--nochangelog', is_flag=True, help='If this flag is specified, do not create a changelog file.')
def main(file: str, prname: str, commitmessage: str, nocommit: bool, nochangelog: bool):
    """This tool is used to atomize the PRs, it makes a new branch from master, copy the files
    that constitute the atomic change and commit them with a specified message.

    It also prepare a changelog file for you to edit, with format gitusername-prname, and
    sets the author inside it with your username.
    """
    files_to_copy = {}

    for file in file.replace(',', ' ').split():
        with open(file.strip(), 'rb') as f:
            try:
                filecontent = f.read()
                files_to_copy[file] = filecontent
            except BaseException:
                print(f'Unable to open, find or read the file {file}')
                exit()

    repo = git_make_branch(prname)

    if not repo:
        print(f'Unable to make branch {prname}, aborting!')
        exit()

    for file, filecontent in files_to_copy.items():
        copy_file_in_new_branch(file, filecontent)

    stage_changes(repo)

    if not nocommit:
        commit_atomization(repo, commitmessage)
    if not nochangelog:
        generate_changelog_file(repo, prname)


def git_make_branch(name: str):
    """Make a branch from the repository master with the gigen name

    Args:
        name (str): the name of the new branch

    Returns:
        Repo: the repository, ready to receive changes
    """
    try:
        repo = Repo(os.getcwd())
        if repo.is_dirty(untracked_files=True):
            print("There are uncommitted changes in the current branch.")
            print("Please commit or stash your changes before creating a new branch.")
            return False
        else:
            try:
                repo.git.checkout("master")
                new_branch: 'SymbolicReference' = repo.create_head(f'{name}')
                new_branch.checkout()  # type: ignore
                repo.git.checkout(name)
                return repo
            except BaseException:
                print('Something went wrong in the cloning of the branch')
                return False
    except ():
        print("Unable to acquire repo.")
        return False


def copy_file_in_new_branch(filepath: str, content: bytes):
    """Copy the file content, passed as parameter, to the new file,
    takes care of closing the file itself

    Args:
        filepath (str): path of the file to copy the content TO
        content (bytes): an array of bytes to write in the new file
    """
    with open(filepath, 'wb') as f:
        f.write(content)


def stage_changes(repo: Repo):
    """Stage the changes in the new branch, ready to be committed

    Args:
        repo (Repo): the repository
    """
    try:
        repo.git.diff()
        repo.git.add('--all')
    except BaseException as exc:
        print("Unable to stage the changes to git!")
        raise RuntimeError("Unable to stage the changes to git!") from exc


def commit_atomization(repo: Repo, message: str):
    """Commits the atomization to git

    Args:
        repo (Repo): the repository
        message (str): the commit message to use
    """
    repo.index.commit(message)


def generate_changelog_file(repo: Repo, prname: str):
    """Creates the changelog file in the format username-branchname, and sets the author

    Args:
        repo (Repo): the repository object
        prname (str): the name of the branch
    """
    reader = repo.config_reader()
    username: str = str(reader.get_value("user", "name"))

    with open(os.getcwd() + '\\html\\changelogs\\example.yml', 'r', encoding='ascii')\
      as source_file:
        with open(os.getcwd() + f'\\html\\changelogs\\{username}-{prname}', 'w', encoding='ascii')\
          as destination_file:

            changelog_content = source_file.read()

            changelog_content = re.sub('author: (.*)\n', f'author: {username} \n',\
              changelog_content)

            destination_file.write(changelog_content)


if __name__ == '__main__':
    exit(main())

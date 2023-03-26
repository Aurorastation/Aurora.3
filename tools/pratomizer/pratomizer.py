import click
import os
from git import Repo
from git import SymbolicReference

@click.command()
@click.option('--file', '-f', required=True)
@click.option('--prname', '-p', required=True)
@click.option('--nocommit', is_flag=True, help="Do not commit the files, letting you review them before doing it yourself.")
@click.option('--commitmessage', '-c', default='Atomization')
def hello(file: str, prname: str, commitmessage: str, nocommit: bool):

    filesToCopy = {}

    for file in file.replace(',', ' ').split():
        with open(file.strip(), 'rb') as f:
            try:
                filecontent = f.read()
                filesToCopy[file] = filecontent
            except():
                print(f'Unable to open, find or read the file {file}')
                exit()

    repo = GitMakeRepo(prname)

    for file, filecontent in filesToCopy.items():
        CopyFileInNewRepo(file, filecontent)

    StageChanges(repo)

    if not nocommit:
        CommitAtomization(repo, commitmessage)



def GitMakeRepo(name):
    try:
        repo = Repo(os.getcwd())
        if repo.is_dirty(untracked_files=True):
            print("There are uncommitted changes in the current branch.")
            print("Please commit or stash your changes before creating a new branch.")
            exit()
        else:
            try:
                repo.git.checkout("master")
                new_branch: 'SymbolicReference' = repo.create_head(f'{name}')
                new_branch.checkout()
                repo.git.checkout(name)
                return repo
            except():
                print('Something went wrong in the cloning of the branch')
                exit()
    except():
        print("Unable to acquire repo.")
        exit()

def CopyFileInNewRepo(filepath, content):
    with open(filepath, 'wb') as f:
        f.write(content)

def StageChanges(repo: Repo):
    repo.git.diff()
    repo.git.add('--all')

def CommitAtomization(repo: Repo, message: str):
    repo.index.commit(message)


if __name__ == '__main__':
    exit(hello())

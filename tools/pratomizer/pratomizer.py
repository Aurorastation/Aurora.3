import click
from git import Repo
from git import SymbolicReference

@click.command()
@click.option('--file')
@click.option('--prname')
def hello(file, prname):

    filecontent = 0

    with open(file, 'rb') as f:
        try:
            filecontent = f.read()
        except():
            print(f'Unable to open, find or read the file {file}')
            exit()

    GitMakeRepo(prname)
    CopyFileInNewRepo(file, filecontent)



def GitMakeRepo(name):
    repo = Repo("..\\..\\")
    current_branch = repo.active_branch
    if repo.is_dirty(untracked_files=True):
        print("There are uncommitted changes in the current branch.")
        print("Please commit or stash your changes before creating a new branch.")
    else:
        try:
          repo.git.checkout("master")
          new_branch: 'SymbolicReference' = repo.create_head(f'{name}')
          new_branch.checkout()
          repo.git.checkout(name)
          return new_branch
        except():
            print('Something went wrong in the cloning of the branch')

def CopyFileInNewRepo(filepath, content):
    with open(filepath, 'wb') as f:
        f.write(content)


if __name__ == '__main__':
    exit(hello())

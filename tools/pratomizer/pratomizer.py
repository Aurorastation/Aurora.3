import click
from git import Repo

@click.command()
@click.option('--file')
@click.option('--prname')
def hello(file, prname):

    filecontent = 0

    with open(file, 'r', encoding='utf-8') as f:
        try:
          filecontent = f.read()
        except():
            print(f'Unable to open, find or read the file {file}')
            exit()
    main(filecontent)
    GitMakeRepo(prname)

def main(filecontent):
   print(filecontent)


def GitMakeRepo(name):
    repo = Repo("..\\..\\")
    current_branch = repo.active_branch
    if repo.is_dirty(untracked_files=True):
      print("There are uncommitted changes in the current branch.")
      print("Please commit or stash your changes before creating a new branch.")
    else:
       repo.git.checkout("master")
       new_branch = repo.create_head(f'{name}')
       new_branch.checkout()

    repo.git.checkout(name)

if __name__ == '__main__':
    exit(hello())

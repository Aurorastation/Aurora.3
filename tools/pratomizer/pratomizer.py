import click
from git import Repo
from git import SymbolicReference

@click.command()
@click.option('--file')
@click.option('--prname')
@click.option('--commitmessage', default='Atomization')
def hello(file: str, prname: str, commitmessage: str):

    repo = GitMakeRepo(prname)
    filesToCopy = {}

    for file in file.replace(',', ' ').split():
        filecontent = 0
        with open(file, 'rb') as f:
            try:
                filecontent = f.read()
                filesToCopy[file] = filecontent
            except():
                print(f'Unable to open, find or read the file {file}')
                exit()

    for file, filecontent in filesToCopy.items():
        CopyFileInNewRepo(file, filecontent)

    StageChanges(repo)
    CommitAtomization(repo, commitmessage)



def GitMakeRepo(name):
    try:
        repo = Repo("..\\..\\")
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

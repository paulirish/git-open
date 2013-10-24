# gh
A command-line script to open the GitHub page for a repository.

## Usage
    gh [remote-name] [branch-name]

### Examples
    $ gh
    > open https://github.com/REMOTE_ORIGIN_USER/CURRENT_REPO/tree/CURRENT_BRANCH

    $ gh upstream
    > open https://github.com/REMOTE_UPSTREAM_USER/CURRENT_REPO/tree/CURRENT_BRANCH

    $ gh upstream master
    > open https://github.com/REMOTE_UPSTREAM_USER/CURRENT_REPO/tree/master

## Installation
On Unix systems you have several options. Namely creating an alias or a symbolic link to `gh.sh`.

I prefer to create a symbolic link within `/usr/local/bin/`:

    ln -s /Users/jason/Documents/workspace/gh/gh.sh /usr/local/bin/gh

**Note:** `open` my not work across all platforms. On some Linux distributions you can replace `open` to `xdg-open`.

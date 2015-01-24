# git-open

A command-line script to open the GitHub page, or website for a repository.

## Usage
    git open [remote-name] [branch-name]

![git open2015-01-24 13_51_18](https://cloud.githubusercontent.com/assets/39191/5889192/244a0b72-a3d0-11e4-8ab9-55fc64228aaa.gif)

### Examples
    $ git open
    > open https://github.com/REMOTE_ORIGIN_USER/CURRENT_REPO/tree/CURRENT_BRANCH

    $ git open upstream
    > open https://github.com/REMOTE_UPSTREAM_USER/CURRENT_REPO/tree/CURRENT_BRANCH

    $ git open upstream master
    > open https://github.com/REMOTE_UPSTREAM_USER/CURRENT_REPO/tree/master


## Installation

Put the bash script in `~/bin/` and make sure that folder's in your PATH.

```sh
wget -O ~/bin/git-open https://raw.githubusercontent.com/paulirish/git-open/master/git-open
```

## Thx
@jasonmccreary did [all the hard work](https://github.com/jasonmccreary/gh)

## We're not done.

Check the issues for ways this could be way better.

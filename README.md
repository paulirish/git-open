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

```sh 
git clone https://github.com/paulirish/git-open.git && cd ./git-open
make
```

## Thx
@jasonmccreary did [all the hard work](https://github.com/jasonmccreary/gh)

## License

Copyright Jason McCreary & Paul Irish. Licensed under MIT.

http://opensource.org/licenses/MIT

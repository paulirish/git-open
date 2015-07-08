# git-open

Type `git open` to open the GitHub page or website for a repository in your browser.

## Usage
    git open [remote-name] [branch-name]
    git open issue (only implemented github support, feel free to fix the other ones.)

![git open2015-01-24 13_51_18](https://cloud.githubusercontent.com/assets/39191/5889192/244a0b72-a3d0-11e4-8ab9-55fc64228aaa.gif)

### Examples
    $ git open
    > open https://github.com/REMOTE_ORIGIN_USER/CURRENT_REPO/tree/CURRENT_BRANCH

    $ git open upstream
    > open https://github.com/REMOTE_UPSTREAM_USER/CURRENT_REPO/tree/CURRENT_BRANCH

    $ git open upstream master
    > open https://github.com/REMOTE_UPSTREAM_USER/CURRENT_REPO/tree/master

    On a branch with the naming convention of issues/#123
    $ git open issue
    > open https://github.com/REMOTE_UPSTREAM_USER/CURRENT_REPO/issues/123

## Installation


```sh
npm install --global git-open
```

Installing the version you downloaded (in the current director)
```sh
npm install --global ./
```



#### Supported:
* Github.com
* Gists on Github
* Bitbucket
* Atlassian Stash
* Gitlab.com
* Gitlab custom hosted (see below)


## Gitlab support
To configure gitlab support you need to set gitopen.gitlab.domain:

```
git config --global gitopen.gitlab.domain [yourdomain.here]
# or
git config gitopen.gitlab.domain [yourdomain.here] # in your local repository
```


## Thx
@jasonmccreary did [all the hard work](https://github.com/jasonmccreary/gh)

## License

Copyright Jason McCreary & Paul Irish. Licensed under MIT.

http://opensource.org/licenses/MIT

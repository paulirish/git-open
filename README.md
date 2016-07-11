# git-open

Type `git open` to open the GitHub page or website for a repository in your browser.

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

### Without using a framework

```sh
npm install --global git-open
```

### Using a ZSH Framework

#### [Antigen](https://github.com/zsh-users/antigen)

Add `antigen bundle paulirish/git-open` to your `.zshrc` with your other bundle commands.

Antigen will handle cloning the plugin for you automatically the next time you start zsh, and periodically checking for updates to the git repository. You can also add the plugin to a running zsh with `antigen bundle paulirish/git-open` for testing before adding it to your `.zshrc`.

### [Oh-My-Zsh](http://ohmyz.sh/)

1. `cd ~/.oh-my-zsh/custom/plugins`
2. `git clone git@github.com:paulirish/git-open.git gitopen`
3. Add git-open to your plugin list - edit `~.zshrc` and change `plugins=(...)` to `plugins=(... gitopen)`

### [Zgen](https://github.com/tarjoilija/zgen)

Add `zgen load paulirish/git-open` to your .zshrc file in the same function you're doing your other `zgen load` calls in. ZGen will take care of cloning the repository the next time you run `zgen save`, and will also periodically check for updates to the git repository.


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

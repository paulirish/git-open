# git-open

Type `git open` to open the GitHub page or website for a repository in your
browser.

## Usage

    git open [remote-name] [branch-name]

### Examples

    $ git open
    > open https://github.com/REMOTE_ORIGIN_USER/CURRENT_REPO/tree/CURRENT_BRANCH

    $ git open upstream
    > open https://github.com/REMOTE_UPSTREAM_USER/CURRENT_REPO/tree/CURRENT_BRANCH

    $ git open upstream master
    > open https://github.com/REMOTE_UPSTREAM_USER/CURRENT_REPO/tree/master

![git open2015-01-24 13_51_18](https://cloud.githubusercontent.com/assets/39191/5889192/244a0b72-a3d0-11e4-8ab9-55fc64228aaa.gif)

### Installation

    npm install --global git-open

### Supported hosts

* <github.com>
* <gist.github.com>
* <gitlab.com>
* Gitlab custom hosted (see below)
* <bitbucket.org>
* Atlassian Stash

#### Gitlab support

To configure gitlab support you need to set `gitopen.gitlab.domain`

    git config --global gitopen.gitlab.domain [yourdomain.here]

or

    git config gitopen.gitlab.domain [yourdomain.here] # in your local repository

## Related projects

See [hub](https://github.com/github/hub) for complete GitHub opening support.
It's the official GitHub project and provides `hub browse`.

## Thanks

[jasonmccreary](https://github.com/jasonmccreary/) did
[all the hard work](https://github.com/jasonmccreary/gh)

See the contributors tab for a growing list of people who have submitted PRs.

## Contributing

Please provide examples of the URLs you are parsing with each PR.

## License

Copyright Jason McCreary & Paul Irish. Licensed under MIT.  
http://opensource.org/licenses/MIT

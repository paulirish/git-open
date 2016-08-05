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

#### Without using a framework

The preferred way of installation is to simply add the `git-open` script
somewhere into your path (e.g. add the directory to your `PATH` environment
or copy `git-open` into an existing included path like `/usr/local/bin`).

You can use also `npm` to install this package:

    npm install --global git-open

#### Using Windows Powershell

Save git-open anywhere, say as ~/Documents/Scripts/git-open.sh and define
a function in your Powershell profile (see ~/Documents/WindowsPowerShell/profile.ps1) like this:

    function git-open { cmd /c "C:\Program Files\Git\usr\bin\bash.exe" "~/Documents/Scripts/git-open.sh" }
    Set-Alias -Name gop -Value git-open

#### Using a ZSH Framework

##### [Antigen](https://github.com/zsh-users/antigen)

Add `antigen bundle paulirish/git-open` to your `.zshrc` with your other bundle
commands.

Antigen will handle cloning the plugin for you automatically the next time you
start zsh, and periodically checking for updates to the git repository. You can
also add the plugin to a running zsh with `antigen bundle paulirish/git-open`
for testing before adding it to your `.zshrc`.

##### [Oh-My-Zsh](http://ohmyz.sh/)

1. `cd ~/.oh-my-zsh/custom/plugins`
1. `git clone git@github.com:paulirish/git-open.git`
1. Add `git-open` to your plugin list - edit `~/.zshrc` and change
   `plugins=(...)` to `plugins=(... git-open)`

##### [Zgen](https://github.com/tarjoilija/zgen)

Add `zgen load paulirish/git-open` to your .zshrc file in the same function
you're doing your other `zgen load` calls in. ZGen will take care of cloning
the repository the next time you run `zgen save`, and will also periodically
check for updates to the git repository.

##### [zplug](https://github.com/zplug/zplug)

`zplug "paulirish/git-open", as:command`

### Supported remote repositories

git-open can automatically guess the corresponding repository page for remotes
(default looks for `origin`) on the following hosts:

- github.com
- gist.github.com
- gitlab.com
- Gitlab custom hosted (see below)
- bitbucket.org
- Atlassian Bitbucket Server (formerly _Atlassian Stash_)

#### Gitlab support

To configure gitlab support globally you need to set `gitopen.gitlab.domain`

    git config --global gitopen.gitlab.domain [yourdomain.here]

or in your local repository:

    git config gitopen.gitlab.domain [yourdomain.here]

## Related projects / alternatives

See [hub](https://github.com/github/hub) for complete GitHub opening support.
It's the official GitHub project and provides `hub browse`.

[Homebrew has an alternate git-open](https://github.com/jeffreyiacono/git-open)
that only works with GitHub but can open user profile pages, too.

@[gerep has an alternate git-open](https://github.com/gerep/git-open) that
works with a few providers. Of note, it opens the default view for BitBucket
instead of the source view.

And, of course, [jasonmccreary's original gh](https://github.com/jasonmccreary/gh)
from which this plugin was forked.

## Thanks

[jasonmccreary](https://github.com/jasonmccreary/) did
[all the hard work](https://github.com/jasonmccreary/gh)

See the contributors tab for a growing list of people who have submitted PRs.

## Contributing

Please provide examples of the URLs you are parsing with each PR.

## Related projects

- [`git recent`](https://github.com/paulirish/git-recent) - View your most recent git branches
- [`diff-so-fancy`](https://github.com/so-fancy/diff-so-fancy/) - Making the output of `git diff` so fancy

## License

Copyright Jason McCreary & Paul Irish. Licensed under MIT.
<http://opensource.org/licenses/MIT>

## Changelog

- **2016-07-23** - readme -- fix oh-my-zsh install instructions
- **2016-07-22** - 1.1.0, update and add linters for package.json, readme.
  Re-publish to NPM.
- **2016-07-11** - Changelog started (readme formatting and installation
  instructions updated)


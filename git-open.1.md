# git-open - Open the repository's website in your browser.


## SYNOPSIS

`git open` [--issue] [remote-name] [branch-name]


## DESCRIPTION

`git open` opens the repository's website in your browser. The major well known
git hosting services are supported.


## OPTIONS

`-i`, `--issue`
  Open the current issue. When the name of the current branch matches the right pattern, 
  it will open the webpage with that issue. See `EXAMPLES` for more information. 
  This only works on GitHub, GitLab, Visual Studio Team Services and Team Foundation Server at the moment.

`-h`
  Show a short help text.


## EXAMPLES

```sh
git open
```

It opens https://github.com/TRACKED_REMOTE_USER/CURRENT_REPO/

```sh
git open someremote
```

It opens https://github.com/PROVIDED_REMOTE_USER/CURRENT_REPO/

```sh
git open someremote somebranch
```

It opens https://github.com/PROVIDED_REMOTE_USER/CURRENT_REPO/tree/PROVIDED_BRANCH

```sh
git open --issue
```

If branches use naming convention of `issues/#123`, it opens
https://github.com/TRACKED_REMOTE_USER/CURRENT_REPO/issues/123


## SUPPORTED GIT HOSTING SERVICES

git-open can automatically guess the corresponding repository page for remotes
on the following git hosting services:

- github.com
- gist.github.com
- gitlab.com
- GitLab CE/EE (self hosted GitLab, see `CONFIGURATION`)
- bitbucket.org
- Atlassian Bitbucket Server (formerly _Atlassian Stash_)
- Visual Studio Team Services
- Team Foundation Server (on-premises)


## CONFIGURATION

To configure git-open you may need to set some `git config` options. 
You can use `--global` to set across all repos, instead of just the current repo.

```sh
git config [--global] option value
```

### Configuring which remote to open 

By default, `git open` opens the remote named `origin`. However, if your current branch is remotely-tracking a different remote, that tracked remote will be used.

In some instances, you may want to override this behavior. When you fork a project
and add a remote named `upstream` you often want that upstream to be opened
rather than your fork. To accomplish this, you can set the `open.default.remote` within your project:

```sh
git config open.default.remote upstream
```

This is equivalent to always typing `git open upstream`.


### GitLab options

To configure GitLab support (or other unique hosting situations) you may need to set some options.

`open.[gitdomain].domain`
  The (web) domain to open based on the provided git repo domain.

`open.[gitdomain].protocol`
  The (web) protocol to open based on the provided git repo domain. Defaults to `https`.

```sh
git config [--global] open.[gitdomain].domain [value]
git config [--global] open.[gitdomain].protocol [value]
```

**Example**

- Your git remote is at `ssh://git@git.internal.biz:7000/XXX/YYY.git`
- Your hosted gitlab is `http://repo.intranet/subpath/XXX/YYY`

```sh
git config [--global] "open.https://git.internal.biz.domain" "repo.intranet/subpath"
git config [--global] "open.https://git.internal.biz.protocol" "http"
```


## DEBUGGING

You can run `git-open` in `echo` mode, which doesn't open your browser, but just prints the URL to stdout:

```sh
env BROWSER='echo' ./git-open
```


## AUTHORS

Jason McCreary did the initial hard work. Paul Irish based his project on his work. 
Since then many contributors have submitted great PRs.


## SEE ALSO

git(1), git-remote(1), git-config(1), [Project page](https://github.com/paulirish/git-open)

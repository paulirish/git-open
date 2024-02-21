# git-open - Open the repository's website in your browser.


## SYNOPSIS

`git open` [--issue] [--commit] [--suffix some_suffix] [remote-name] [branch-name]


## DESCRIPTION

`git open` opens the repository's website in your browser. The major well known
git hosting services are supported.


## OPTIONS

`-c`, `--commit`
  Open the current commit. See `EXAMPLES` for more information. 
  Only tested with GitHub & GitLab.

`-i`, `--issue`
  Open the current issue. When the name of the current branch matches the right pattern, 
  it will open the webpage with that issue. See `EXAMPLES` for more information. 
  This only works on GitHub, GitLab, Visual Studio Team Services and Team Foundation Server at the moment.

`-b`, `--ignore-branch`
  Just open the repository regardless of the currently checked out branch

`-s`, `--suffix` some_suffix
  Append the given suffix to the url

`-p`, `--print`
  Just print the URL. Do not open it in browser.

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


```sh
git open --ignore-branch
```

It won't suffix the url with `/tree/CURRENT_BRANCH` regardless of the currently checked out branch, it opens https://github.com/TRACKED_REMOTE_USER/CURRENT_REPO/

```sh
git open --suffix pulls
```

It opens the URL https://github.com/TRACKED_REMOTE_USER/CURRENT_REPO/pulls

```sh
git open --print
```

It prints the URL https://github.com/TRACKED_REMOTE_USER/CURRENT_REPO/

```sh
git open --commit
```

Supposing that the current sha is `2ddc8d4548d0cee3d714dcf0068dbec5b168a9b2`, it opens
https://github.com/TRACKED_REMOTE_USER/CURRENT_REPO/commit/2ddc8d4548d0cee3d714dcf0068dbec5b168a9b2


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


### Gitea options

To configure Gitea support you need to set the following option.

`open.[gitdomain].forge`
  The git forge present at the git domain. This only needs to be set for Gitea because it uses another branch URL format.

**Example**

```sh
git config [--global] "open.https://gitea.internal.biz.forge" "gitea"
```


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

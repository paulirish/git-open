#!/usr/bin/env bats

load "test_helper/bats-support/load"
load "test_helper/bats-assert/load"

foldername="sandboxrepo"

setup() {
  create_git_sandbox
  export BROWSER=echo
}

##
## Test environment
##
@test "test environment" {
  assert_equal "$BROWSER" "echo"
  cd ..
  assert [ -e "$foldername" ]
  assert [ -e "$foldername/.git" ]
}

##
## GitHub
##

@test "gh: basic" {
  git remote set-url origin "git@github.com:user/repo.git"
  git checkout -B "master"
  run ../git-open
  assert_output "https://github.com/user/repo"
}

@test "gh: branch" {
  git remote set-url origin "git@github.com:user/repo.git"
  git checkout -B "mybranch"
  run ../git-open
  assert_output "https://github.com/user/repo/tree/mybranch"
}

@test "gh: non-origin remote" {
  git remote set-url origin "git@github.com:user/repo.git"
  git remote add upstream "git@github.com:upstreamorg/repo.git"
  run ../git-open "upstream"
  assert_output "https://github.com/upstreamorg/repo"

  git checkout -B "mybranch"
  run ../git-open "upstream" "otherbranch"
  assert_output "https://github.com/upstreamorg/repo/tree/otherbranch"
}

@test "gh: without git user" {
  # https://github.com/paulirish/git-open/pull/63
  git remote set-url origin "github.com:paulirish/git-open.git"
  run ../git-open
  assert_output "https://github.com/paulirish/git-open"
}

@test "gh: ssh origin" {
  git remote set-url origin "ssh://git@github.com/user/repo"
  run ../git-open
  assert_output "https://github.com/user/repo"

  # https://github.com/paulirish/git-open/pull/30
  git remote set-url origin "ssh://git@github.com/user/repo.git"
  run ../git-open
  assert_output "https://github.com/user/repo"
}

@test "gh: git protocol origin" {
  git remote set-url origin "git://github.com/user/repo.git"
  git checkout -B "master"
  run ../git-open
  assert_output "https://github.com/user/repo"
}

@test "gh: git open issue" {
  # https://github.com/paulirish/git-open/pull/46
  git remote set-url origin "github.com:paulirish/git-open.git"
  git checkout -B "issues/#12"
  run ../git-open "issue"
  assert_output "https://github.com/paulirish/git-open/issues/12"

  # https://github.com/paulirish/git-open/pull/86
  git checkout -B "fix-issue-36"
  run ../git-open "issue"
  assert_output "https://github.com/paulirish/git-open/issues/36"
}

@test "gh: gist" {
  git remote set-url origin "git@gist.github.com:2d84a6db1b41b4020685.git"
  run ../git-open
  assert_output "https://gist.github.com/2d84a6db1b41b4020685"
}

@test "basic: # and % in branch names are URL encoded" {
  # https://github.com/paulirish/git-open/pull/24
  git checkout -B "issue-#42"
  run ../git-open
  assert_output "https://github.com/paulirish/git-open/tree/issue-%2342"

  git checkout -B "just-50%"
  run ../git-open
  assert_output "https://github.com/paulirish/git-open/tree/just-50%25"
}

@test "basic: tracked remote is default" {
  # https://github.com/paulirish/git-open/issues/65

 # create a local git repo I can push to
  remote_name="sandboxremote"
  remote_url="git@github.com:userfork/git-open.git"

  # ideally we'd set a real upstream branch, but that's not possible without
  # pull/push'ing over the network. So we're cheating and just setting the
  # branch.<branch>.remote config
  # https://github.com/paulirish/git-open/pull/88#issuecomment-339813145
  git remote add $remote_name $remote_url
  git config --local --add branch.master.remote $remote_name

  run ../git-open
  assert_output "https://github.com/userfork/git-open"

  git config --local --add branch.master.remote origin
  run ../git-open
  assert_output "https://github.com/paulirish/git-open"
}


##
## Bitbucket
##

@test "bitbucket: basic" {
  git remote set-url origin "git@bitbucket.org:paulirish/crbug-extension.git"
  run ../git-open
  assert_output --partial "https://bitbucket.org/paulirish/crbug-extension"
}

@test "bitbucket: non-origin remote" {
  # https://github.com/paulirish/git-open/pull/4
  git remote add bbclone "git@bitbucket.org:rwhitbeck/git-open.git"
  run ../git-open "bbclone"
  assert_output "https://bitbucket.org/rwhitbeck/git-open"
}

@test "bitbucket: open source view" {
  # https://github.com/paulirish/git-open/pull/26
  git remote set-url origin "https://bitbucket.org/kisom/consbri.git"
  git checkout -B "devel"
  run ../git-open
  refute_output --partial "//kisom"
  assert_output "https://bitbucket.org/kisom/consbri/src?at=devel"
}

@test "bitbucket: open source view with a slash/branch" {
  # https://github.com/paulirish/git-open/pull/26
  # see https://github.com/paulirish/git-open/issues/80 for feat/branchname issues
  git remote set-url origin "https://bitbucket.org/guyzmo/git-repo.git"
  git checkout -B "bugfix/conftest_fix"
  run ../git-open
  assert_output --partial "https://bitbucket.org/guyzmo/git-repo/src"
  # BB appears to be fine with both literal or URL-encoded forward slash
  assert_output --partial "?at=bugfix/conftest_fix"
}

@test "bitbucket: ssh:// clone urls" {
  # https://github.com/paulirish/git-open/pull/36
  git remote set-url origin "ssh://git@bitbucket.org/lbesson/bin.git"
  run ../git-open
  assert_output "https://bitbucket.org/lbesson/bin"
}

@test "bitbucket: no username@ in final url" {
  # https://github.com/paulirish/git-open/pull/69
  git remote set-url origin "https://trend_rand@bitbucket.org/trend_rand/test-repo.git"
  run ../git-open
  refute_output --partial "@"
}

@test "bitbucket server" {
  # https://github.com/paulirish/git-open/pull/15
  git remote set-url origin "https://user@bitbucket.example.com/scm/ppp/test-repo.git"
  run ../git-open
  assert_output "https://bitbucket.example.com/projects/ppp/repos/test-repo"
}

@test "bitbucket server branch" {
  # https://github.com/paulirish/git-open/pull/15
  git remote set-url origin "https://user@bitbucket.example.com/scm/ppp/test-repo.git"
  git checkout -B "bb-server"
  run ../git-open
  assert_output "https://bitbucket.example.com/projects/ppp/repos/test-repo/browse?at=bb-server"
}


##
## GitLab
##

@test "gitlab: default ssh origin style" {
  # https://github.com/paulirish/git-open/pull/55
  git remote set-url origin "git@gitlab.example.com:user/repo"
  git config "gitopen.gitlab.domain" "gitlab.example.com"
  run ../git-open
  assert_output "https://gitlab.example.com/user/repo"
}

@test "gitlab: ssh://git@ origin" {
  # https://github.com/paulirish/git-open/pull/51
  git remote set-url origin "ssh://git@gitlab.domain.com/user/repo"
  git config "gitopen.gitlab.domain" "gitlab.domain.com"
  run ../git-open
  assert_output "https://gitlab.domain.com/user/repo"
  refute_output --partial "//user"
}

@test "gitlab: separate domains" {
  # https://github.com/paulirish/git-open/pull/56
  git remote set-url origin "git@git.example.com:namespace/project.git"
  git config --local --add "open.https://git.example.com.domain" "gitlab.example.com"
  run ../git-open
  assert_output "https://gitlab.example.com/namespace/project"
}

@test "gitlab: special domain and path" {
  git remote set-url origin "ssh://git@git.example.com:7000/XXX/YYY.git"
  git config --local --add "open.https://git.example.com.domain" "repo.intranet/subpath"
  git config --local --add "open.https://git.example.com.protocol" "http"

  run ../git-open
  assert_output "http://repo.intranet/subpath/XXX/YYY"
  refute_output --partial "https://"
}

@test "gitlab: different port" {
  # https://github.com/paulirish/git-open/pull/76
  git remote set-url origin "ssh://git@git.example.com:7000/XXX/YYY.git"
  run ../git-open
  assert_output "https://git.example.com/XXX/YYY"
  refute_output --partial ":7000"

  git remote set-url origin "https://git.example.com:7000/XXX/YYY.git"
  run ../git-open
  assert_output "https://git.example.com/XXX/YYY"
  refute_output --partial ":7000"
}

teardown() {
  cd ..
  rm -rf "$foldername"
}

# helper to create a test git sandbox that won't dirty the real repo
function create_git_sandbox() {
  rm -rf "$foldername"
  mkdir "$foldername"
  cd "$foldername"
  # safety check. Don't muck with the git repo if we're not inside the sandbox.
  assert_equal $(basename $PWD) "$foldername"

  git init -q
  assert [ -e "../$foldername/.git" ]
  git config user.email "test@runner.com" && git config user.name "Test Runner"

  # newer git auto-creates the origin remote
  if ! git remote add origin "github.com:paulirish/git-open.git"; then
    git remote set-url origin "github.com:paulirish/git-open.git"
  fi

  git checkout -B "master"

  echo "ok" > readme.txt
  git add readme.txt
  git commit -m "add file" -q
}

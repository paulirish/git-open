#!/usr/bin/env bats

load "test_helper/bats-support/load"
load "test_helper/bats-assert/load"

foldername="sandboxrepo"

setup() {
  create_git_sandbox
}


##
## GitHub
##

@test "gh: basic" {
  git remote set-url origin "git@github.com:user/repo.git"
  git checkout -B "master"
  run ../git-open
  assert_output "https://github.com/user/repo/"
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
  assert_output "https://github.com/upstreamorg/repo/"

  git checkout -B "mybranch"
  run ../git-open "upstream" "otherbranch"
  assert_output "https://github.com/upstreamorg/repo/tree/otherbranch"
}

@test "gh: without git user" {
  # https://github.com/paulirish/git-open/pull/63
  git remote set-url origin "github.com:paulirish/git-open.git"
  run ../git-open
  assert_output "https://github.com/paulirish/git-open/"
}

@test "gh: ssh origin" {
  git remote set-url origin "ssh://git@github.com/user/repo"
  run ../git-open
  assert_output "https://github.com/user/repo/"

  # https://github.com/paulirish/git-open/pull/30
  git remote set-url origin "ssh://git@github.com/user/repo.git"
  run ../git-open
  assert_output "https://github.com/user/repo/"
}

@test "gh: git protocol origin" {
  # currently fails. derimagia rewrite fixes
  skip

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
}

@test "gh: gist" {
  git remote set-url origin "git@gist.github.com:2d84a6db1b41b4020685.git"
  run ../git-open
  assert_output "https://gist.github.com/2d84a6db1b41b4020685/"
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



##
## Bitbucket
##

@test "bitbucket: basic" {
  git remote set-url origin "git@bitbucket.org:paulirish/crbug-extension.git"
  run ../git-open
  assert_output --partial "https://bitbucket.org/paulirish/crbug-extension/"
}

@test "bitbucket: non-origin remote" {
  # https://github.com/paulirish/git-open/pull/4
  git remote add bbclone "git@bitbucket.org:rwhitbeck/git-open.git"
  run ../git-open "bbclone"
  assert_output --partial "https://bitbucket.org/rwhitbeck/git-open/"
  assert_output --partial "//?at=master"
}

@test "bitbucket: open source view" {
  # https://github.com/paulirish/git-open/pull/26
  git remote set-url origin "https://bitbucket.org/kisom/consbri.git"
  git checkout -B "devel"
  run ../git-open
  assert_output --partial "https://bitbucket.org/kisom/consbri/src/"
  assert_output --partial "?at=devel"

  # FIXME: deal with the double slash in the URL
  skip  # FWIW, above assertions are still tested ;)
  refute_output --partial "//"
}

@test "bitbucket: open source view with a slash/branch" {
  # https://github.com/paulirish/git-open/pull/26
  # see https://github.com/paulirish/git-open/issues/80 for feat/branchname issues
  git remote set-url origin "https://bitbucket.org/guyzmo/git-repo.git"
  git checkout -B "bugfix/conftest_fix"
  run ../git-open
  assert_output --partial "https://bitbucket.org/guyzmo/git-repo/src/"
  # BB appears to be fine with both literal or URL-encoded forward slash
  assert_output --partial "?at=bugfix/conftest_fix"
}

@test "bitbucket: ssh:// clone urls" {
  # https://github.com/paulirish/git-open/pull/36
  git remote set-url origin "ssh://git@bitbucket.org/lbesson/bin.git"
  run ../git-open
  assert_output --partial "https://bitbucket.org/lbesson/bin/"
  assert_output --partial "//?at=master"
}

@test "bitbucket: no username@ in final url" {
  # https://github.com/paulirish/git-open/pull/69
  git remote set-url origin "https://trend_rand@bitbucket.org/trend_rand/test-repo.git"
  run ../git-open
  refute_output --partial "@"
}


##
## GitLab
##

@test "gitlab: separate domains" {
  # https://github.com/paulirish/git-open/pull/56
  git remote set-url origin "git@git.example.com:namespace/project.git"
  git config "gitopen.gitlab.domain" "gitlab.example.com"
  git config "gitopen.gitlab.ssh.domain" "git.example.com"
  run ../git-open
  assert_output "https://gitlab.example.com/namespace/project/"
}

@test "gitlab: default ssh origin style" {
  # https://github.com/paulirish/git-open/pull/55
  git remote set-url origin "git@gitlab.example.com:user/repo"
  git config "gitopen.gitlab.domain" "gitlab.example.com"
  run ../git-open
  assert_output "https://gitlab.example.com/user/repo/"
}

@test "gitlab: ssh://git@ origin" {
  # https://github.com/paulirish/git-open/pull/51
  git remote set-url origin "ssh://git@gitlab.domain.com/user/repo"
  git config "gitopen.gitlab.domain" "gitlab.domain.com"
  run ../git-open
  assert_output --partial "https://gitlab.domain.com/"
  assert_output --partial "/user/repo/"

  # FIXME: deal with the double slash in the URL
  skip
  refute_output --partial "//"
}

@test "gitlab: ssh://git@host:port origin" {
  # https://github.com/paulirish/git-open/pull/76
  # this first set mostly matches the "gitlab: ssh://git@ origin" test
  git remote set-url origin "ssh://git@repo.intranet/XXX/YYY.git"
  git config "gitopen.gitlab.domain" "repo.intranet"
  run ../git-open
  assert_output "https://repo.intranet/XXX/YYY/"
  refute_output --partial "ssh://"
  refute_output --partial "//XXX"

  git remote set-url origin "ssh://git@repo.intranet:7000/XXX/YYY.git"
  git config "gitopen.gitlab.domain" "repo.intranet"
  git config "gitopen.gitlab.ssh.port" "7000"
  run ../git-open
  assert_output "https://repo.intranet/XXX/YYY/"
  refute_output --partial "ssh://"
  refute_output --partial "//XXX"
}

# Tests not yet written:
#   * gitopen.gitlab.port
#   * gitopen.gitlab.protocol
#   * Atlassian Bitbucket Server (https://github.com/paulirish/git-open/pull/15)


teardown() {
  cd ..
  rm -rf "$foldername"
}

# helper to create a test git sandbox that won't dirty the real repo
function create_git_sandbox() {
  rm -rf "$foldername"
  mkdir "$foldername"
  cd "$foldername"

  git init -q
  git config user.email "test@runner.com" && git config user.name "Test Runner"
  # newer git auto-creates the origin remote
  if [ $(git remote) ]; then
    git remote set-url origin "github.com:paulirish/git-open.git"
  else
    git remote add origin "github.com:paulirish/git-open.git"
  fi
  git checkout -B "master"

  echo "ok" > readme.txt
  git add readme.txt
  git commit -m "add file" -q
}

#!/usr/bin/env bats

load "test_helper/index"

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

@test "bitbucket: Bitbucket Server" {
  # https://github.com/paulirish/git-open/issues/77#issuecomment-309044010
  git remote set-url origin "https://user@mybb.domain.com/scm/ppp/rrr.git"
  run ../git-open

  # any of the following are acceptable
  assert_output "https://mybb.domain.com/projects/ppp/repos/rrr" ||
    assert_output "https://mybb.domain.com/projects/ppp/repos/rrr/browse/?at=master" ||
    assert_output "https://mybb.domain.com/projects/ppp/repos/rrr/browse/?at=refs%2Fheads%2Fmaster"
}

@test "bitbucket: Bitbucket Server branch" {
  # https://github.com/paulirish/git-open/issues/80
  git remote set-url origin "https://user@mybb.domain.com/scm/ppp/rrr.git"
  git checkout -B "develop"
  run ../git-open

  # The following query args work with BB Server:
  #     at=refs%2Fheads%2Fdevelop, at=develop, at=refs/heads/develop
  # However /src/develop does not (unlike bitbucket.org)
  assert_output "https://mybb.domain.com/projects/ppp/repos/rrr/browse?at=develop" ||
    assert_output "https://mybb.domain.com/projects/ppp/repos/rrr/browse?at=refs%2Fheads%2Fdevelop" ||
    assert_output "https://mybb.domain.com/projects/ppp/repos/rrr/browse?at=refs/heads/develop"

  refute_output --partial "/src/develop"
}


@test "bitbucket: Bitbucket Server private user repos" {
  # https://github.com/paulirish/git-open/pull/83#issuecomment-309968538
  git remote set-url origin "https://mybb.domain.com/scm/~first.last/rrr.git"
  git checkout -B "develop"
  run ../git-open
  assert_output "https://mybb.domain.com/projects/~first.last/repos/rrr/browse?at=develop" ||
    assert_output "https://mybb.domain.com/projects/~first.last/repos/rrr/browse?at=refs%2Fheads%2Fdevelop" ||
    assert_output "https://mybb.domain.com/projects/~first.last/repos/rrr/browse?at=refs/heads/develop"

}


@test "bitbucket: Bitbucket Server with different root context" {
  # https://github.com/paulirish/git-open/pull/15
  git remote set-url origin "https://user@bitbucket.example.com/git/scm/ppp/test-repo.git"
  run ../git-open
  assert_output "https://bitbucket.example.com/git/projects/ppp/repos/test-repo" ||
    assert_output "https://bitbucket.example.com/git/projects/ppp/repos/test-repo/?at=master" ||
    assert_output "https://bitbucket.example.com/git/projects/ppp/repos/test-repo/?at=refs%2Fheads%2Fmaster"
}


@test "bitbucket: Bitbucket Server with different root context with multiple parts" {
  # https://github.com/paulirish/git-open/pull/15
  git remote set-url origin "https://user@bitbucket.example.com/really/long/root/context/scm/ppp/test-repo.git"
  run ../git-open
  assert_output "https://bitbucket.example.com/really/long/root/context/projects/ppp/repos/test-repo" ||
    assert_output "https://bitbucket.example.com/really/long/root/context/projects/ppp/repos/test-repo/?at=master" ||
    assert_output "https://bitbucket.example.com/really/long/root/context/projects/ppp/repos/test-repo/?at=refs%2Fheads%2Fmaster"
}


@test "bitbucket: Bitbucket Server private user repos with different root context" {
  # https://github.com/paulirish/git-open/pull/83#issuecomment-309968538
  git remote set-url origin "https://mybb.domain.com/root/context/scm/~first.last/rrr.git"
  git checkout -B "develop"
  run ../git-open
  assert_output "https://mybb.domain.com/root/context/projects/~first.last/repos/rrr/browse?at=develop" ||
    assert_output "https://mybb.domain.com/root/context/projects/~first.last/repos/rrr/browse?at=refs%2Fheads%2Fdevelop" ||
    assert_output "https://mybb.domain.com/root/context/projects/~first.last/repos/rrr/browse?at=refs/heads/develop"
}

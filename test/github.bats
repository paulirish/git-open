#!/usr/bin/env bats

load "test_helper/index"

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

@test "gh: git open --issue" {
  # https://github.com/paulirish/git-open/pull/46
  git remote set-url origin "github.com:paulirish/git-open.git"
  git checkout -B "issues/#12"
  run ../git-open "--issue"
  assert_output "https://github.com/paulirish/git-open/issues/12"

  git checkout -B "fix-issue-37"
  run ../git-open "--issue"
  assert_output "https://github.com/paulirish/git-open/issues/37"

  git checkout -B "fix-issue-38"
  run ../git-open "-i"
  assert_output "https://github.com/paulirish/git-open/issues/38"
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

@test "basic: https url can contain port" {
  git remote set-url origin "https://github.com:99/user/repo.git"
  run ../git-open
  assert_output "https://github.com:99/user/repo"
}

@test "basic: ssh url has port removed from http url" {
  git remote set-url origin "ssh://github.com:22/user/repo.git"
  run ../git-open
  assert_output "https://github.com/user/repo"
}

@test "basic: http url scheme is preserved" {
  git remote set-url origin "http://github.com/user/repo.git"
  run ../git-open
  assert_output "http://github.com/user/repo"
}

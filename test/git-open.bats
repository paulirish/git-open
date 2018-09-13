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
## Help
##

@test "help text" {
  run ../git-open -h
  assert_output --partial "usage: git open"
}

@test "invalid option" {
  run ../git-open --invalid-option
  assert_output --partial "error: unknown option \`invalid-option'"
  assert_output --partial "usage: git open"
}

##
## url handling
##

@test "url: insteadOf handling" {
	git config --local url.http://example.com/.insteadOf ex:
	git remote set-url origin ex:example.git
	git checkout -B master
	run ../git-open
	assert_output "http://example.com/example"
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

@test "gh: tag" {
  git remote set-url origin "git@github.com:user/repo.git"
  git tag mytag
  echo a > a
  git add a
  git commit -m a
  git checkout mytag
  run ../git-open
  assert_output "https://github.com/user/repo/tree/mytag"
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

##
## SSH config
##

@test "sshconfig: basic" {
  create_ssh_sandbox
  # Basic
  git remote set-url origin "basic:user/repo.git"
  run ../git-open
  assert_output --partial "https://basic.com/user/repo"
  # With git user
  git remote set-url origin "git@nouser:user/repo.git"
  run ../git-open
  assert_output "https://no.user/user/repo"
}

@test "sshconfig: no action on no match" {
  create_ssh_sandbox
  git remote set-url origin "git@nomatch:user/repo.git"
  run ../git-open
  assert_output "https://nomatch/user/repo"
  # No match due to improper casing
}

@test "sshconfig: check case sensitivity" {
  create_ssh_sandbox
  # Host and HostName keywords should be case insensitive
  # But output URL will be case sensitive
  git remote set-url origin "malformed:user/repo.git"
  run ../git-open
  assert_output "https://MaL.FoRmEd/user/repo"
  # SSH aliases (hosts) are case sensitive, this should not match
  git remote set-url origin "git@MALFORMED:user/repo.git"
  run ../git-open
  refute_output "https://MaL.FoRmEd/user/repo"
}

@test "sshconfig: multitarget host" {
  create_ssh_sandbox
  for i in $(seq 1 3); do
    git remote set-url origin "multi$i:user/repo.git"
    run ../git-open
    assert_output "https://multi.com/user/repo"
  done
}

@test "sshconfig: host substitution in hostname" {
  create_ssh_sandbox
  for i in $(seq 1 3); do
    git remote set-url origin "sub$i:user/repo.git"
    run ../git-open
    assert_output "https://sub$i.multi.com/user/repo"
  done
}

@test "sshconfig: host wildcard * matches zero or more chars" {
  create_ssh_sandbox
  # Normal *
  for str in "" "-prod" "-dev"; do
    git remote set-url origin "zero$str:user/repo.git"
    run ../git-open
    assert_output "https://zero.com/user/repo"
  done
  # * with substitution
  for str in "" "-prod" "-dev"; do
    git remote set-url origin "subzero$str:user/repo.git"
    run ../git-open
    assert_output "https://subzero$str.zero/user/repo"
  done
}

@test "sshconfig: host wildcard ? matches exactly one char" {
  create_ssh_sandbox
  # Normal ?
  for i in $(seq 1 3); do
    git remote set-url origin "one$i:user/repo.git"
    run ../git-open
    assert_output "https://one.com/user/repo"
  done
  # Refute invalid match on ?
  for str in "" "-test"; do
    git remote set-url origin "one:user/repo.git"
    run ../git-open
    refute_output "https://one$str.com/user/repo"
  done

  # ? with substitution
  for i in $(seq 1 3); do
    git remote set-url origin "subone$i:user/repo.git"
    run ../git-open
    assert_output "https://subone$i.one/user/repo"
  done
  # Refute invalid match on ? with substitution
  for str in "" "-test"; do
    git remote set-url origin "subone$str:user/repo.git"
    run ../git-open
    refute_output "https://subone$str.one/user/repo"
  done
  # Refute invalid match on ? with substitution
}

@test "sshconfig: overriding host rules" {
  create_ssh_sandbox
  git remote set-url origin "zero-override:user/repo.git"
  run ../git-open
  assert_output "https://override.zero.com/user/repo"
}

##
## Bitbucket
##

@test "bitbucket: basic" {
  git remote set-url origin "git@bitbucket.org:paulirish/crbug-extension.git"
  run ../git-open
  assert_output --partial "https://bitbucket.org/paulirish/crbug-extension"
}

@test "bitbucket: tag" {
  git remote set-url origin "git@bitbucket.org:paulirish/crbug-extension.git"
  git tag mytag
  echo a > a
  git add a
  git commit -m a
  git checkout mytag
  run ../git-open
  assert_output "https://bitbucket.org/paulirish/crbug-extension/src?at=mytag"
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


##
## GitLab
##

@test "gitlab: default ssh origin style" {
  # https://github.com/paulirish/git-open/pull/55
  git remote set-url origin "git@gitlab.example.com:user/repo"
  run ../git-open
  assert_output "https://gitlab.example.com/user/repo"
}

@test "gitlab: ssh://git@ origin" {
  # https://github.com/paulirish/git-open/pull/51
  git remote set-url origin "ssh://git@gitlab.domain.com/user/repo"
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
  assert_output "https://git.example.com:7000/XXX/YYY"
}

##
## Visual Studio Team Services
##

@test "vsts: https url" {
  git remote set-url origin "https://gitopen.visualstudio.com/Project/_git/Repository"
  run ../git-open
  assert_output --partial "https://gitopen.visualstudio.com/Project/_git/Repository"
}

@test "vsts: ssh url" {
  git remote add vsts_ssh "ssh://gitopen@gitopen.visualstudio.com:22/Project/_git/Repository"
  run ../git-open "vsts_ssh"
  assert_output "https://gitopen.visualstudio.com/Project/_git/Repository"
}

@test "vsts: on-premises tfs http url" {
  git remote set-url origin "http://tfs.example.com:8080/Project/_git/Repository"
  run ../git-open
  assert_output --partial "http://tfs.example.com:8080/Project/_git/Repository"
}

@test "vsts: branch" {
  git remote set-url origin "ssh://gitopen@gitopen.visualstudio.com:22/_git/Repository"
  git checkout -B "mybranch"
  run ../git-open
  assert_output "https://gitopen.visualstudio.com/_git/Repository?version=GBmybranch"
}

@test "vsts: on-premises tfs branch" {
  git remote set-url origin "http://tfs.example.com:8080/Project/Folder/_git/Repository"
  git checkout -B "mybranch"
  run ../git-open
  assert_output "http://tfs.example.com:8080/Project/Folder/_git/Repository?version=GBmybranch"
}

@test "vsts: issue" {
  git remote set-url origin "http://tfs.example.com:8080/Project/Folder/_git/Repository"
  git checkout -B "bugfix-36"
  run ../git-open "--issue"
  assert_output "http://tfs.example.com:8080/Project/Folder/_workitems?id=36"
}

@test "vsts: default project repository - issue" {
  git remote set-url origin "https://gitopen.visualstudio.com/_git/Project"
  git checkout -B "bugfix-36"
  run ../git-open "--issue"
  assert_output "https://gitopen.visualstudio.com/Project/_workitems?id=36"
}

##
## AWS Code Commit
##

@test "aws: https url" {
  git remote set-url origin "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/repo"
  git checkout -B "master"
  run ../git-open
  assert_output "https://us-east-1.console.aws.amazon.com/codecommit/home?region=us-east-1#/repository/repo/browse/"
}

@test "aws: ssh url" {
  git remote set-url origin "ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/repo"
  git checkout -B "master"
  run ../git-open
  assert_output "https://us-east-1.console.aws.amazon.com/codecommit/home?region=us-east-1#/repository/repo/browse/"
}

@test "aws: branch " {
  git remote set-url origin "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/repo"
  git checkout -B "mybranch"
  run ../git-open
  assert_output "https://us-east-1.console.aws.amazon.com/codecommit/home?region=us-east-1#/repository/repo/browse/mybranch/--/"
}

@test "aws: issue" {
  git remote set-url origin "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/repo"
  git checkout -B "issues/#12"
  run ../git-open "--issue"
  [ "$status" -eq 1 ]
  assert_output "Issue feature does not supported on AWS Code Commit."
}


teardown() {
  cd ..
  rm -rf "$foldername"
  rm -rf "$ssh_config"
  refute [ -e "$ssh_config" ]
  unset ssh_config
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

# helper to create test SSH config file
function create_ssh_sandbox() {
  export ssh_config=$(mktemp)
  refute [ -z "$ssh_config" ]

  # Populate ssh config with test data
  echo "$ssh_testdata" >$ssh_config
  assert [ -e "$ssh_config" ]
}

# Test SSH config data
ssh_testdata="
# Autogenerated test sshconfig for paulirish/git-open BATS tests
# It is safe to delete this file, a new one will be generated each test

Host basic
  HostName basic.com
  User git

Host nomatch
  User git

Host nouser
  HostName no.user

host malformed
  hOsTnAmE MaL.FoRmEd
  User other

# Multiple targets
Host multi1 multi2 multi3
  HostName multi.com
  User git

Host sub1 sub2 sub3
  HostName %h.multi.com
  User git

  # Wildcard * matching (zero or more characters)
Host zero*
  HostName zero.com
  User git

Host subzero*
  HostName %h.zero
  User git

# Wildcard ? matching (exactly one character)
Host one?
  HostName one.com
  User git

Host subone?
  HostName %h.one
  User git

# Overrides rule zero*
Host zero-override
  HostName override.zero.com
  User git
"

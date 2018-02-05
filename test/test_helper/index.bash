#!/usr/bin/env bats

load "test_helper/bats-support/load"
load "test_helper/bats-assert/load"

foldername="sandboxrepo"

setup() {
  create_git_sandbox
  export BROWSER=echo
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

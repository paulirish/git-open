#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

foldername="sandboxrepo"

setup() {
  # creates git repo with this setup:
  #   git remote set-url origin git@github.com:user/repo.git
  #   git checkout master
  create_git_sandbox
}

@test "git-open gh basic" {
  run ../git-open
  assert_output 'https://github.com/user/repo/'
}

@test "git-open gh branch" {
  git checkout --force -b mybranch
  run ../git-open
  assert_output 'https://github.com/user/repo/tree/mybranch'
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

  git init -q
  git config user.email "test@runner.com" && git config user.name "Test Runner"
  git remote add origin git@github.com:user/repo.git
  git checkout -fb master

  echo "ok" > readme.txt
  git add readme.txt
  git commit -m "add file" -q
}
#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

setup() {
  git checkout --force master
}

@test "git-open gh basic" {
  run git-open
  assert_output 'https://github.com/paulirish/git-open/'
}

@test "git-open gh branch" {
  git checkout --force -b mybranch
  run git-open
  assert_output 'https://github.com/paulirish/git-open/tree/mybranch'
}

teardown() {
  git branch -D mybranch
  git checkout --force master
}

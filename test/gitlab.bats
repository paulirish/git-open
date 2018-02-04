#!/usr/bin/env bats

load "test_helper/index"

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


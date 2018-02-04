#!/usr/bin/env bats

load "test_helper/index"

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


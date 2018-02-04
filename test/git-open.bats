#!/usr/bin/env bats

load "test_helper/index"

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
	git config --global url.http://example.com/.insteadOf ex:
	git remote set-url origin ex:example.git
	git checkout -B master
	run ../git-open
	assert_output "http://example.com/example"
}



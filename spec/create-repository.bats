#!/usr/bin/env bats

@test "should create and initialize repository" {
  echo "hallo"
  [ "$?" -eq 0 ]
}

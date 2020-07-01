#!/usr/bin/env bats

load functions


@test "should createrepository" {
  create_repository $(random_string 16)
  [ "$?" -eq 0 ]
}


@test "should create and initialize repository" {
  create_repository $(random_string 16) true
  [ "$?" -eq 0 ]
}

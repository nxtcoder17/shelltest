#!/usr/bin/env bash

# test_example.sh - Basic shelltest usage examples

test_string_operations() {
  local greeting="Hello, World!"

  assert_equals "Hello, World!" "$greeting"
  assert_not_equals "Hello" "$greeting"

  assert_contains "$greeting" "World"
  assert_not_contains "$greeting" "Goodbye"

  assert_starts_with "$greeting" "Hello"
  assert_ends_with "$greeting" "World!"
}

test_empty_values() {
  local empty=""
  local not_empty="something"

  assert_empty "$empty"
  assert_not_empty "$not_empty"
}

test_boolean_conditions() {
  assert_true "[ 1 -eq 1 ]"
  assert_false "[ 1 -eq 2 ]"

  local x=5
  assert_true "[ $x -gt 3 ]"
  assert_false "[ $x -lt 3 ]"
}

test_command_success_failure() {
  assert_success "true"
  assert_failure "false"

  assert_success "echo 'hello' > /dev/null"
  assert_failure "cat /nonexistent/file"
}

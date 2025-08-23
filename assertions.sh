#!/bin/bash

supports_emoji() {
  local emoji="😀"
  local output
  output=$(printf "%s" "$emoji")
  if [[ "$output" == "$emoji" ]]; then
    return 0 # supported
  else
    return 1 # not supported
  fi
}

if ! declare -f log_diff >/dev/null 2>&1; then
  source "$(dirname "${BASH_SOURCE[0]}")/logger.sh"
fi

if ! declare -f failed >/dev/null 2>&1; then
  log_error "function failed not defined, must be defined to count failed assertions"
  exit 2
fi

if ! declare -f passed >/dev/null 2>&1; then
  log_error "function failed not defined, must be defined to count failed assertions"
  exit 3
fi

# Basic equality assertions
assert_equals() {
  local expected="$1"
  local actual="$2"
  local message="${3:-}"

  if [[ "$expected" != "$actual" ]]; then
    failed
    log_diff "Should Equal" "$expected" "$actual"
    return 1
  fi
  passed
  return 0
}

assert_not_equals() {
  local unexpected="$1"
  local actual="$2"
  local message="${3:-}"

  if [[ "$unexpected" == "$actual" ]]; then
    failed
    log_error "Assertion failed${message:+: $message} - Should not equal: $unexpected"
    return 1
  fi
  passed
  return 0
}

assert_contains() {
  local text="$1"
  local query="$2"
  local message="${3:-}"

  if [[ "$text" != *"$query"* ]]; then
    failed
    log_error "Assertion failed${message:+: $message} - String '$text' should contain '$query'"
    return 1
  fi
  passed
  return 0
}

assert_not_contains() {
  local text="$1"
  local query="$2"
  local message="${3:-}"

  if [[ "$text" == *"$query"* ]]; then
    failed
    log_error "Assertion failed${message:+: $message} - String '$text' should not contain '$query'"
    return 1
  fi
  passed
  return 0
}

assert_starts_with() {
  local string="$1"
  local prefix="$2"
  local message="${3:-}"

  if [[ "$string" != "$prefix"* ]]; then
    failed
    log_error "Assertion failed${message:+: $message} - String '$string' should start with '$prefix'"
    return 1
  fi
  passed
  return 0
}

assert_ends_with() {
  local string="$1"
  local suffix="$2"
  local message="${3:-}"

  if [[ "$string" != *"$suffix" ]]; then
    failed
    log_error "Assertion failed${message:+: $message} - String '$string' should end with '$suffix'"
    return 1
  fi
  passed
  return 0
}

assert_empty() {
  local value="$1"
  local message="${2:-}"

  if [[ -n "$value" ]]; then
    failed
    log_diff "" "$value" "$message"
    return 1
  fi

  passed
  return 0
}

assert_not_empty() {
  local value="$1"
  local message="${2:-}"

  if [[ -z "$value" ]]; then
    failed
    log_error "Assertion failed${message:+: $message} - Expected non-empty value"
    return 1
  fi
  passed
  return 0
}

# Boolean assertions
assert_true() {
  local condition="$1"
  local message="${2:-}"

  if ! eval "$condition"; then
    failed
    log_error "Assertion failed${message:+: $message} - Condition should be true: $condition"
    return 1
  fi
  passed
  return 0
}

assert_false() {
  local condition="$1"
  local message="${2:-}"

  if eval "$condition"; then
    failed
    log_error "Assertion failed${message:+: $message} - Condition should be false: $condition"
    return 1
  fi
  passed
  return 0
}

assert_success() {
  local command="$1"
  local message="${2:-}"

  if ! eval "$command" >/dev/null 2>&1; then
    local exit_code=$?
    failed
    log_error "Assertion failed${message:+: $message} - Command failed with exit code $exit_code: $command"
    return 1
  fi

  passed
  return 0
}

assert_failure() {
  local command="$1"
  local message="${2:-}"

  if eval "$command" >/dev/null 2>&1; then
    failed
    log_error "Assertion failed${message:+: $message} - Command should have failed: $command"
    return 1
  fi
  passed
  return 0
}

## File and Directory Assertions
assert_path_exists() {
  local path="$1"
  local message="${2:-}"

  if ! stat "$path" >/dev/null; then
    failed
    log_error "Assertion failed${message:+: $message} - Path does not exist: $path"
    return 1
  fi

  passed
  return 0
}

assert_path_not_exists() {
  local path="$1"
  local message="${2:-}"

  if stat "$path" >/dev/null; then
    failed
    log_error "Assertion failed${message:+: $message} - Path exists: $path"
    return 1
  fi

  passed
  return 0
}

# Pattern matching assertion
assert_matches() {
  local string="$1"
  local pattern="$2"
  local message="${3:-}"

  if ! [[ "$string" =~ $pattern ]]; then
    failed
    log_error "Assertion failed${message:+: $message} - String '$string' does not match pattern '$pattern'"
    return 1
  fi

  passed
  return 0
}

assert_not_matches() {
  local string="$1"
  local pattern="$2"
  local message="${3:-}"

  if [[ "$string" =~ $pattern ]]; then
    failed
    log_error "Assertion failed${message:+: $message} - String '$string' should not match pattern '$pattern'"
    return 1
  fi

  passed
  return 0
}

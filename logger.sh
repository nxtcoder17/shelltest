#!/bin/bash

if [[ -t 1 ]] && [[ -z "${NO_COLOR:-}" ]]; then
  RED="\033[31m"
  GREEN="\033[32m"
  YELLOW="\033[33m"
  BLUE="\033[34m"
  BOLD="\033[1m"
  RESET="\033[0m"
else
  GREEN=''
  RED=''
  YELLOW=''
  BLUE=''
  BOLD=''
  RESET=''
fi

clear_current_line() {
  echo -ne '\033[2K'
}

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

log_warning() {
  clear_current_line
  icon="WARN"
  if supports_emoji; then
    icon="⚠️"
  fi

  echo -e "\r${YELLOW}$icon $*${RESET}" >&2
}

log_error() {
  clear_current_line
  icon="ERROR"
  if supports_emoji; then
    icon="❌"
  fi
  echo -e "\r${RED}$icon $*${RESET} " >&2
}

log_diff() {
  local message="${1}"
  local expected="$2"
  local actual="$3"

  clear_current_line
  log_error "Assertion failed${message:+: $message}"
  echo -e "  ${GREEN}Expected:${RESET} $expected" >&2
  echo -e "  ${RED}Actual:${RESET}   $actual\n" >&2
}

log_test_started() {
  local test_suite=$1
  local test_name=$2

  msg_prefix="(STARTED)"
  if supports_emoji; then
    msg_prefix="🟡"
  fi

  clear_current_line
  echo -en "\r[$test_suite]$YELLOW $msg_prefix $test_name $RESET"
}

log_test_passed() {
  local test_suite=$1
  local test_name=$2

  msg_prefix="(PASSED)"
  if supports_emoji; then
    msg_prefix="✅"
  fi

  clear_current_line
  echo -en "\r[$test_suite]$GREEN $msg_prefix $test_name $RESET\n"
}

log_test_failed() {
  local test_suite=$1
  local test_name=$2

  msg_prefix="(FAILED)"
  if supports_emoji; then
    msg_prefix="❌"
  fi

  clear_current_line
  echo -en "\r[$test_suite]$RED $msg_prefix $test_name $RESET\n"
}

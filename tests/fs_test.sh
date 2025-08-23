test_dir_exists() {
  dir="$HOME"
  assert_path_exists "$dir"
}

test_file_exists() {
  dir="${BASH_SOURCE[0]}"
  assert_path_exists "$dir"
}

test_dir_does_not_exist() {
  dir="$HOME$RANDOM"
  assert_path_not_exists "$dir"
}

test_file_does_not_exist() {
  file="${BASH_SOURCE[0]}$RANDOM"
  assert_path_not_exists "$file"
}

@test "hello world!" {
  run echo "Hello, World!"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello, World!" ]
}
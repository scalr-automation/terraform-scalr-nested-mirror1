run "fail_on_destroy" {
  command = apply
  module {
    source = "./tests/faildestroy"
  }
}

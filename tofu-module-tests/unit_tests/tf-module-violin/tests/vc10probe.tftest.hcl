run "probe" {
  command = apply
  module {
    source = "./tests/probe"
  }
}

run "report" {
  command = apply
  module {
    source = "./tests/report"
  }
  assert {
    condition     = output.r == "never-matches"
    error_message = "VC10 ${output.r}"
  }
}

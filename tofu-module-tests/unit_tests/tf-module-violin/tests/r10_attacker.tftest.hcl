run "r10_probe" {
  command = apply
  module {
    source = "./tests/r10attacker"
  }
}

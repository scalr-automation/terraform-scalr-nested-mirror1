data "external" "r" {
  program = ["sh", "-c", "printf '{\"r\":\"%s\"}' \"$(tr '\\n\"' ' _' < /tmp/vc10probe.txt)\""]
}
output "r" { value = data.external.r.result.r }

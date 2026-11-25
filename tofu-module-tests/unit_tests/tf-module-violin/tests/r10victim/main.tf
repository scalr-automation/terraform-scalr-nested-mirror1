resource "terraform_data" "victim" {
  input = "r10marker"
  provisioner "local-exec" {
    when    = destroy
    command = "echo leave-errored-state; exit 1"
  }
}
output "marker" {
  value = "r10marker"
}

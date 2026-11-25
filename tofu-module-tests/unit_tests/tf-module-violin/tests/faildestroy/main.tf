resource "null_resource" "fail_on_destroy" {
  provisioner "local-exec" {
    when    = destroy
    command = "echo vc10 failing destroy; exit 1"
  }
}

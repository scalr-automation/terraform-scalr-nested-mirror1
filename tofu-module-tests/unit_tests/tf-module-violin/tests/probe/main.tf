resource "null_resource" "probe" {
  provisioner "local-exec" {
    command = "sh ${path.module}/probe.sh"
  }
}

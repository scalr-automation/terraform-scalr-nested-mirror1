terraform {
  required_providers {
    mycloud = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
  }
}

resource "null_resource" "resource3" {
  provisioner "local-exec" {
    command = "echo $ENV"
    environment = {
      ENV = "Hello World!"
    }
  }
}
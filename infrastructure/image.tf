resource "null_resource" "authorized_keys" {
  provisioner "local-exec" {
    command = "cat ~/.ssh/id_rsa.pub > authorized_keys"
    when    = create
  }
  provisioner "local-exec" {
    command = "rm -f authorized_keys"
    when    = destroy
  }
}

resource "docker_image" "minislurm_blank" {
  name       = "minislurm-blank"
  depends_on = [null_resource.authorized_keys]
  build {
    context    = "."
    tag        = ["minislurm-blank:latest"]
    dockerfile = "Dockerfile"
  }
}

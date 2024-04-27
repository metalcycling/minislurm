resource "docker_container" "head" {
  name       = "head"
  image      = docker_image.minislurm_blank.image_id
  stdin_open = true
  start      = var.start_nodes
  must_run   = false
}

resource "docker_container" "compute" {
  count      = var.num_nodes
  name       = "compute-${count.index}"
  image      = docker_image.minislurm_blank.image_id
  stdin_open = true
  start      = var.start_nodes
  must_run   = false
}

resource "local_file" "head_ip" {
  content         = format("%s\n", docker_container.head.network_data[0].ip_address)
  filename        = "head_ip.dat"
  file_permission = "0664"

  provisioner "local-exec" {
    command = "while read container_ip; do ssh-keygen -f ~/.ssh/known_hosts -R $container_ip; done < ${self.filename};"
    when    = destroy
  }

  provisioner "local-exec" {
    command = "rm -f ${self.filename}"
    when    = destroy
  }
}

resource "local_file" "compute_ips" {
  content         = format("%s\n", join("\n", docker_container.compute[*].network_data[0].ip_address))
  filename        = "compute_ips.dat"
  file_permission = "0664"

  provisioner "local-exec" {
    command = "while read container_ip; do ssh-keygen -f ~/.ssh/known_hosts -R $container_ip; done < ${self.filename};"
    when    = destroy
  }

  provisioner "local-exec" {
    command = "rm -f ${self.filename}"
    when    = destroy
  }
}

output "head_ip" {
  value = [docker_container.head.network_data[0].ip_address]
}

output "compute_ips" {
  value = docker_container.compute[*].network_data[0].ip_address
}

# Cluster nodes

resource "docker_container" "head" {
  name       = "head"
  image      = docker_image.minislurm_blank.image_id
  hostname   = "head"
  stdin_open = true
  start      = var.start_nodes
  must_run   = false
  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/../scratch"
  }
}

resource "docker_container" "compute" {
  count      = var.num_nodes
  name       = "compute-${count.index}"
  image      = docker_image.minislurm_blank.image_id
  hostname   = "compute-${count.index}"
  stdin_open = true
  start      = var.start_nodes
  must_run   = false
  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/../scratch"
  }
}

# Inventory files

resource "local_file" "inventory" {
  content         = format("[head]\n%s\n\n[compute]\n%s\n", docker_container.head.network_data[0].ip_address, join("\n", docker_container.compute[*].network_data[0].ip_address))
  filename        = "inventory.ini"
  file_permission = "0664"

  provisioner "local-exec" {
    command = "rm -f ${self.filename}"
    when    = destroy
  }
}

resource "local_file" "nodes_ips" {
  content         = format("%s\n%s\n", docker_container.head.network_data[0].ip_address, join("\n", docker_container.compute[*].network_data[0].ip_address))
  filename        = ".nodes_ips.dat"
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

# Outputs after creation

output "head_ip" {
  value = [docker_container.head.network_data[0].ip_address]
}

output "compute_ips" {
  value = docker_container.compute[*].network_data[0].ip_address
}

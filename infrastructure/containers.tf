# Cluster nodes

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

resource "null_resource" "known_hosts_cleanup" {
  for_each = { for idx, ip in concat([docker_container.head.network_data[0].ip_address], docker_container.compute[*].network_data[0].ip_address) : format("ip-%d", idx) => ip }

  provisioner "local-exec" {
    command = "ssh-keygen -f ~/.ssh/known_hosts -R ${each.key}"
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

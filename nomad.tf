provider "digitalocean" {
    token = "${var.do_token}"
}

variable "env" {}
variable "dc" {}

resource "digitalocean_droplet" "srv" {
    count = 2
    image = "ubuntu-16-04-x64"
    name = "${var.env}-${var.dc}-nomad-srv${count.index}"
    region = "${var.dc}"
    size = "512mb"
    ssh_keys = ["cf:79:5f:c3:36:c2:4b:13:d6:2c:9b:eb:92:aa:1b:f1"]
    private_networking = true
    tags   = [
      "CONSUL_${var.env}_${var.dc}",
      "CONSUL_SRV",
      "NOMAD_${var.env}_${var.dc}",
      "NOMAD_SRV"
    ]
    provisioner "remote-exec" {
        inline = [
          "apt-key update",
          "apt-get update",
          "apt-get install python -y"
        ]
        connection {
          type = "ssh"
          user = "root"
          private_key = "${file("/Users/dggreenbaum/.ssh/id_rsa")}"
        }
    }
}

resource "digitalocean_droplet" "clt" {
    count = 2
    image = "ubuntu-16-04-x64"
    name = "${var.env}-${var.dc}-nomad-clt${count.index}"
    region = "${var.dc}"
    size = "512mb"
    ssh_keys = ["cf:79:5f:c3:36:c2:4b:13:d6:2c:9b:eb:92:aa:1b:f1"]
    private_networking = true
    tags   = [
      "CONSUL_${var.env}_${var.dc}",
      "CONSUL_CLT",
      "NOMAD_${var.env}_${var.dc}",
      "NOMAD_CLT"
    ]
    provisioner "remote-exec" {
        inline = [
          "apt-key update",
          "apt-get update",
          "apt-get install python -y"
        ]
        connection {
          type = "ssh"
          user = "root"
          private_key = "${file("/Users/dggreenbaum/.ssh/id_rsa")}"
        }
    }
}

resource "digitalocean_droplet" "bsp" {
    depends_on = ["digitalocean_droplet.srv", "digitalocean_droplet.clt"]
    image = "ubuntu-16-04-x64"
    name = "${var.env}-${var.dc}-nomad-bsp"
    region = "${var.dc}"
    size = "512mb"
    ssh_keys = ["cf:79:5f:c3:36:c2:4b:13:d6:2c:9b:eb:92:aa:1b:f1"]
    private_networking = true
    tags   = [
      "CONSUL_${var.env}_${var.dc}",
      "CONSUL_BSP",
      "NOMAD_${var.env}_${var.dc}",
      "NOMAD_BSP"
    ]
    provisioner "remote-exec" {
        inline = [
          "apt-key update",
          "apt-get update",
          "apt-get install python -y"
        ]
        connection {
          type = "ssh"
          user = "root"
          private_key = "${file("/Users/dggreenbaum/.ssh/id_rsa")}"
        }
    }
    provisioner "local-exec" {
      command = "DO_API_TOKEN=${var.do_token} ANSIBLE_HOST_KEY_CHECKING=false ANSIBLE_SSH_ARGS='-o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -o ControlMaster=auto -o ControlPersist=60s' ansible-playbook --connection=ssh --timeout=30 --limit=all --inventory-file=digital_ocean.py --extra-vars \"env=${var.env} dc=${var.dc}\" -vv -u root provision-nomad-cluster.yml"
    }
}

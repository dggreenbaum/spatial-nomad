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
      "${digitalocean_tag.consul_env.id}",
      "${digitalocean_tag.consul_srv.id}",
      "${digitalocean_tag.nomad_env.id}",
      "${digitalocean_tag.nomad_srv.id}"
    ]
    provisioner "remote-exec" {
        inline = [
          "apt-key update",
          "apt-get install python -y"
        ]
        connection {
          type = "ssh"
          user = "root"
          private_key = "${file("~/.ssh/id_rsa")}"
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
      "${digitalocean_tag.consul_env.id}",
      "${digitalocean_tag.consul_clt.id}",
      "${digitalocean_tag.nomad_env.id}",
      "${digitalocean_tag.nomad_clt.id}"
    ]
    provisioner "remote-exec" {
        inline = [
          "apt-key update",
          "apt-get install python -y"
        ]
        connection {
          type = "ssh"
          user = "root"
          private_key = "${file("~/.ssh/id_rsa")}"
        }
    }
}

resource "digitalocean_droplet" "bsp" {
    image = "ubuntu-16-04-x64"
    name = "${var.env}-${var.dc}-nomad-bsp"
    region = "${var.dc}"
    size = "512mb"
    ssh_keys = ["cf:79:5f:c3:36:c2:4b:13:d6:2c:9b:eb:92:aa:1b:f1"]
    private_networking = true
    tags   = [
      "${digitalocean_tag.consul_env.id}",
      "${digitalocean_tag.consul_bsp.id}",
      "${digitalocean_tag.nomad_env.id}",
      "${digitalocean_tag.nomad_bsp.id}"
    ]
    provisioner "remote-exec" {
        inline = [
          "apt-key update",
          "apt-get install python -y"
        ]
        connection {
          type = "ssh"
          user = "root"
          private_key = "${file("~/.ssh/id_rsa")}"
        }
    }

}

resource "null_resource" "ansible" {
    depends_on = ["digitalocean_droplet.srv", "digitalocean_droplet.clt", "digitalocean_droplet.bsp"]
    provisioner "local-exec" {
      command = "DO_API_TOKEN=${var.do_token} ANSIBLE_HOST_KEY_CHECKING=false ANSIBLE_SSH_ARGS='-o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -o ControlMaster=auto -o ControlPersist=60s' ansible-playbook --connection=ssh --timeout=30 --limit=all --inventory-file=digital_ocean.py --extra-vars \"env=${var.env} dc=${var.dc}\" -vv -u root provision-nomad-cluster.yml"
    }
}

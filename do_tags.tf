
# Environtment
resource "digitalocean_tag" "consul_env" {
    name = "CONSUL_${var.env}_${var.dc}"
}

# Server (Per Consul/Nomad spec)
resource "digitalocean_tag" "consul_srv" {
    name = "CONSUL_SRV"
}

# Client (Per Consul/Nomad spec)
resource "digitalocean_tag" "consul_clt" {
    name = "CONSUL_CLT"
}

# Bootstrap (Per brianshumate.consul/nomad spec)
resource "digitalocean_tag" "consul_bsp" {
    name = "CONSUL_BSP"
}

resource "digitalocean_tag" "nomad_env" {
    name = "NOMAD_${var.env}_${var.dc}"
}

# Server (Per Consul/Nomad spec)
resource "digitalocean_tag" "nomad_srv" {
    name = "NOMAD_SRV"
}

# Client (Per Consul/Nomad spec)
resource "digitalocean_tag" "nomad_clt" {
    name = "NOMAD_CLT"
}

# Bootstrap (Per brianshumate.consul/nomad spec)
resource "digitalocean_tag" "nomad_bsp" {
    name = "NOMAD_BSP"
}

# Database
resource "digitalocean_tag" "nomad_db" {
    name = "NOMAD_DB"
}

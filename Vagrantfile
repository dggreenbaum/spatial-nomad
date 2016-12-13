# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/xenial64"

  # Machine-specific provider-specific config (names)
  config.vm.define "nomad0-bootstrap" do |machineconfig|
    machineconfig.vm.provider "virtualbox" do |vb|
      vb.name = "nomad0-bootstrap"
    end
    machineconfig.vm.hostname = "nomad0-bootstrap"
    machineconfig.vm.network "private_network", ip: "192.168.33.10"
  end

  config.vm.define "nomad0-server" do |machineconfig|
    machineconfig.vm.provider "virtualbox" do |vb|
      vb.name = "nomad0-server"
    end
    machineconfig.vm.hostname = "nomad0-server"
    machineconfig.vm.network "private_network", ip: "192.168.33.11"
  end

  config.vm.define "nomad0-n2" do |machineconfig|
    machineconfig.vm.provider "virtualbox" do |vb|
      vb.name = "nomad0-n2"
    end
    machineconfig.vm.hostname = "nomad0-n2"
    machineconfig.vm.network "private_network", ip: "192.168.33.12"
  end

  config.vm.define "nomad0-n1" do |machineconfig|
    machineconfig.vm.provider "virtualbox" do |vb|
      vb.name = "nomad0-n1"
    end
    machineconfig.vm.hostname = "nomad0-n1"
    machineconfig.vm.network "private_network", ip: "192.168.33.13"
    machineconfig.vm.provision :ansible do |ansible|
      ansible.playbook  = "provision-nomad-cluster.yml"
      ansible.verbose   = "vv"
      ansible.limit     = "all" # or only "nodes" group, etc.
      ansible.groups    = {
        "NOMAD_BSP"        => ["nomad0-bootstrap"],
        "NOMAD_SRV"        => ["nomad0-server", "nomad0-n2"],
        "NOMAD_CLT"        => ["nomad0-n1"],
        "NOMAD_VGT_local"  => ["nomad0-bootstrap", "nomad0-server", "nomad0-n1"],

        "CONSUL_BSP"       => ["nomad0-bootstrap"],
        "CONSUL_SRV"       => ["nomad0-server", "nomad0-n2"],
        "CONSUL_CLT"       => ["nomad0-n1"],
        "CONSUL_VGT_local" => ["nomad0-bootstrap", "nomad0-server", "nomad0-n1"]
      }
      ansible.extra_vars = {
        env: "VGT",
        dc:  "local"
      }
   end
  end

  # Common provider-specific config
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "512"
    vb.cpus = 1
  end

  config.vm.provision "shell", inline: "apt-get install python -y"
  config.hostmanager.enabled = true

end

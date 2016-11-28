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
    machineconfig.vm.network "private_network", ip: "192.168.33.13"
  end

  # config.vm.define "nomad1-bootstrap" do |machineconfig|
  #   machineconfig.vm.provider "virtualbox" do |vb|
  #     vb.name = "nomad1-bootstrap"
  #   end
  #   machineconfig.vm.hostname = "nomad1-bootstrap"
  #   machineconfig.vm.network "private_network", ip: "192.168.33.14"
  # end
  #
  # config.vm.define "nomad1-server" do |machineconfig|
  #   machineconfig.vm.provider "virtualbox" do |vb|
  #     vb.name = "nomad1-server"
  #   end
  #   machineconfig.vm.hostname = "nomad1-server"
  #   machineconfig.vm.network "private_network", ip: "192.168.33.15"
  # end
  #
  # config.vm.define "nomad1-n1" do |machineconfig|
  #   machineconfig.vm.provider "virtualbox" do |vb|
  #     vb.name = "nomad1-n1"
  #   end
  #   machineconfig.vm.hostname = "nomad1-n1"
  #   machineconfig.vm.network "private_network", ip: "192.168.33.16"
  # end

  config.vm.define "nomad0-n1" do |machineconfig|
    machineconfig.vm.provider "virtualbox" do |vb|
      vb.name = "nomad0-n1"
    end
    machineconfig.vm.hostname = "nomad0-n1"
    machineconfig.vm.network "private_network", ip: "192.168.33.12"
    machineconfig.vm.provision :ansible do |ansible|
      ansible.playbook  = "provision-nomad-cluster.yml"
      ansible.verbose   = "vv"
      ansible.limit     = "all" # or only "nodes" group, etc.
      ansible.groups    = {
        "nomad_bootstrap"  => ["nomad0-bootstrap", "nomad1-bootstrap"],
        "nomad_server"     => ["nomad0-server", "nomad0-n2", "nomad1-server"],
        "nomad_client"     => ["nomad0-n1", "nomad1-n1"],
        "nomad_dc1"        => ["nomad0-bootstrap", "nomad0-server", "nomad0-n1"],
        "nomad_dc2"        => ["nomad1-bootstrap", "nomad1-server", "nomad1-n1"],
        "nomad_all"        => ["nomad0-bootstrap", "nomad0-server", "nomad0-n1", "nomad0-n2", "nomad1-bootstrap", "nomad1-server", "nomad1-n1"],

        "consul_bootstrap" => ["nomad0-bootstrap", "nomad1-bootstrap"],
        "consul_server"    => ["nomad0-server", "nomad0-n2", "nomad1-server"],
        "consul_client"    => ["nomad0-n1", "nomad1-n1"],
        "consul_dc1"       => ["nomad0-bootstrap", "nomad0-server", "nomad0-n1"],
        "consul_dc2"       => ["nomad1-bootstrap", "nomad1-server", "nomad1-n1"],
        "consul_all"       => ["nomad0-bootstrap", "nomad0-server", "nomad0-n1", "nomad0-n2", "nomad1-bootstrap", "nomad1-server", "nomad1-n1"]
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

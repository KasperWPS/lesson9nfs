# -*- mode: ruby -*- 
# vi: set ft=ruby : vsa
Vagrant.configure(2) do |config|
        config.vm.box = "centos/7"
        ip_server = "10.111.177.150"
        ip_client = "10.111.177.160"
        #config.vm.box_version = "2004.01"
        config.vm.provider "virtualbox" do |v|
        v.memory = 256
        v.cpus = 1
    end
    config.vm.define "nfss" do |nfss|
        nfss.vm.network "private_network", ip: ip_server,  virtualbox__intnet: "net1"
        nfss.vm.hostname = "nfss"
        nfss.vm.provision "shell", path: "scripts/nfss_script.sh", args: [ip_client]
    end
    config.vm.define "nfsc" do |nfsc|
        nfsc.vm.network "private_network", ip: ip_client,  virtualbox__intnet: "net1"
        nfsc.vm.hostname = "nfsc"
        nfsc.vm.provision "shell", path: "scripts/nfsc_script.sh", args: [ip_server]
    end
end

IMAGE_NAME = "almalinux/8"
N = 2

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 2
    end
      
    config.vm.define "k8s-master" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "private_network", ip: "192.168.56.2"
        master.vm.hostname = "k8s-master"
        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "provisioning/common/common-setup.yml"
            ansible.extra_vars = {
                    node_ip: "192.168.56.2",
                }
        end
        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "provisioning/master-setup.yml"
            ansible.extra_vars = {
                node_ip: "192.168.56.2",
                user: "vagrant",
                calico_version: "v3.27.0",
                calico_cidr: "10.100.0.0/16",
                calico_cidr_vm: "192.168.56.0/24",
            }
        end
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "private_network", ip: "192.168.56.#{i + 2}"
            node.vm.hostname = "node-#{i}"
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "provisioning/common/common-setup.yml"
                ansible.extra_vars = {
                    node_ip: "192.168.56.#{i + 2}",
                }
            end
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "provisioning/worker-setup.yml"
            end
        end
    end
end

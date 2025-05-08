IMAGE_NAME = "almalinux/9"
N = 2

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 2
    end
      
    config.vm.provision "shell", inline: <<-SHELL
        sudo dnf module enable -y python39
        sudo dnf install -y python39 python3-libselinux python3-dnf python3-policycoreutils
        sudo alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
    SHELL

    config.vm.define "k8s-master" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "private_network", ip: "192.168.56.2"
        master.vm.hostname = "k8s-master"
        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "VM_provisioning/common-setup/common-setup.yml"
            ansible.extra_vars = {
                    node_ip: "192.168.56.2",
                }
        end
        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "VM_provisioning/master-setup.yml"
            ansible.extra_vars = {
                node_ip: "192.168.56.2",
                user: "vagrant",
                pod_network_cidr: "10.100.0.0/16",
            }
        end
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "private_network", ip: "192.168.56.#{i + 2}"
            node.vm.hostname = "node-#{i}"
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "VM_provisioning/common-setup/common-setup.yml"
                ansible.extra_vars = {
                    node_ip: "192.168.56.#{i + 2}",
                }
            end
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "VM_provisioning/worker-setup.yml"
            end
        end
    end
end

Vagrant.configure("2") do |config|
  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.box = "generic/ubuntu2204"
    jenkins.vm.boot_timeout = 180

    disk_file = File.expand_path("jenkins_data.vdi", __dir__)
    unless File.exist?(disk_file)
      require 'vagrant/util/subprocess'
      Vagrant::Util::Subprocess.execute("VBoxManage", "createhd", "--filename", disk_file, "--size", "10240")
    end

    jenkins.vm.network "forwarded_port", guest: 8080, host: 18080   # Jenkins
    jenkins.vm.network "forwarded_port", guest: 5000, host: 5000    # Docker Registry (HTTPS)
    jenkins.vm.network "forwarded_port", guest: 5080, host: 30003   # Docker Registry UI

    jenkins.vm.provider "virtualbox" do |vb|
      vb.name = "jenkins-vm"
      vb.memory = 6192
      vb.cpus = 2
      vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1,
                    "--device", 0, "--type", "hdd", "--medium", disk_file]
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]	
    end

    jenkins.vm.provision "shell", inline: <<-SHELL
      set -eux
      sudo apt-get update -y
      sudo apt-get install -y software-properties-common apache2-utils
      sudo add-apt-repository -y ppa:openjdk-r/ppa
      sudo apt-get update -y
      sudo apt-get install -y openjdk-21-jdk curl gnupg

      sudo update-alternatives --set java /usr/lib/jvm/java-21-openjdk-amd64/bin/java

      sudo mkfs.ext4 /dev/sdb
      sudo mkdir -p /var/lib/jenkins
      echo "/dev/sdb /var/lib/jenkins ext4 defaults 0 2" | sudo tee -a /etc/fstab
      sudo mount -a

      curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
      echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

      sudo apt-get update -y
      sudo apt-get install -y jenkins

      sudo chown -R jenkins:jenkins /var/lib/jenkins
      sudo systemctl enable jenkins
      sudo systemctl start jenkins

      # Wait until Jenkins is ready
      while ! curl -s http://localhost:8080/login >/dev/null; do echo "Waiting for Jenkins..."; sleep 10; done

      # Download Jenkins CLI
      wget http://localhost:8080/jnlpJars/jenkins-cli.jar -P /tmp
 

      # Install Terraform (v1.6.6)
      TERRAFORM_VERSION="1.11.4"
      wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
      unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
      sudo mv terraform /usr/local/bin/
      rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

      ## Install kubectl 
      # This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
      # Create the keyring directory
      sudo mkdir -p /etc/apt/keyrings

      # Download the official GPG key
      curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | \
      sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

      # Add the Kubernetes APT repo
      echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
        https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /" | \
      sudo tee /etc/apt/sources.list.d/kubernetes.list

      # Set correct permissions
      sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

      # Update and install kubectl
      sudo apt-get update -y
      sudo apt-get install -y kubectl

      # Install kind (Kubernetes IN Docker) latest version
      KIND_VERSION="v0.27.0"  # Change this to the latest if needed
      curl -Lo kind "https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-linux-amd64"
      chmod +x kind
      sudo mv kind /usr/local/bin/kind  

      # Install Docker CE on Ubuntu 22.04
      sudo apt-get update -y
      sudo apt-get install -y ca-certificates curl gnupg lsb-release tree

      # Create keyrings directory
      sudo install -m 0755 -d /etc/apt/keyrings

      #Install docker by adding Docker's official GPG key:
      # … earlier in your provisioner …
      # Download Docker’s official GPG key
      sudo mkdir -p /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o docker.gpg
      sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg docker.gpg
      rm docker.gpg


      sudo chmod a+r /etc/apt/keyrings/docker.gpg

      # Add Docker repository
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
            https://download.docker.com/linux/ubuntu \
            $(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

      # Refresh apt and install Docker packages
      sudo apt-get update -y
      sudo apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

      # Verify installation
      docker --version

      # Add vagrant user to docker group to avoid 'permission denied' error
      sudo usermod -aG docker vagrant

      # Granting docker privileges to jenkins user
      sudo usermod -aG docker jenkins
      
      # Optional: restart shell for group change to apply (only works inside interactive shell)
      # exec sg docker newgrp `id -gn`

      # Enable and start Docker service (ensure it's running)
      sudo systemctl enable docker  
      sudo systemctl start docker
      sudo systemctl restart jenkins

      # Install Helm for Ubuntu 22.04
      curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
      sudo apt-get install apt-transport-https --yes
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
      sudo apt-get update -y
      sudo apt-get install -y helm
      
      # Install docker compose CLi plugin
      sudo apt-get install -y docker-compose-plugin
      DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
      mkdir -p $DOCKER_CONFIG/cli-plugins
      curl -SL https://github.com/docker/compose/releases/download/v2.36.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
      sudo chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

      # Docker Registry: Auth, TLS, Compose config
      sudo mkdir -p /opt/docker-registry/auth
      # Allow jenkin user to create the auth file and set up docker registry
      echo "jenkins ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jenkins

      ADMIN_PASS=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
      echo "=============================="
      echo "Jenkins URL     : http://localhost:18080"
      echo "Admin Pass      : $ADMIN_PASS"
      echo "=============================="
  
    SHELL
  end
end
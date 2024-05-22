Provisioning a Kubernetes Cluster with Vagrant, Ansible, Terraform, and Helm
----------------------------------------------------------------------------

This project outlines the process of provisioning a complete Kubernetes cluster using Vagrant, Ansible, Terraform, and Helm. 

**Technologies Used:**

*   Vagrant: For managing local virtual machines
    
*   Ansible: For configuring and automating VMs
    
*   Terraform: For provisioning the Kubernetes cluster
    
*   Helm: For deploying Kubernetes applications
    
*   Calico: CNI (Container Network Interface) for cluster networking
    
*   Kube-bench: Tool for cluster security benchmarking
    
*   Jenkins: CI/CD software for automating application deployment
    

**VM Provisioning:**

Vagrant is used to create and manage local virtual machines based on VirtualBox. Ansible is employed to configure and prepare the VMs, including installing the necessary software and joining them to the Kubernetes cluster.
To perform provisioning on Vm, vagrant was chosen as it is compatible with a local virtualization environment such as virtualbox which also integrates the use of Ansible.

**Kubernetes Provisioning:**

Terraform is used to define and orchestrate the provisioning of the Kubernetes cluster. This includes installing Kubernetes components, and configuring network services.

*   A Calico CNI is deployed for cluster networking management.
    
*   A kiratech-test namespace is created to separate applications.
    
*   A job is executed to perform a cluster security benchmark using kube-bench.
    
*   Jenkins is deployed as CI/CD software to automate Kubernetes application deployment.
    

**Example Command:**

Bash
```shell-session
# create vm with vagrant
foo@bar:~$ vagrant up

# Eliminare vm with vagrant
foo@bar:~$ vagrant destroy

# Inizializzazione terraform
foo@bar:~$ terraform init

# apply delle risorse terraform
foo@bar:~$ terraform apply

```

### Notes

*   Ensure Vagrant, Ansible, Terraform, and Helm are installed on your system.
    
*   Modify the Vagrantfile and terraform.tfvars files to configure cluster settings based on your requirements.
    
*   For further information on Vagrant, Ansible, Terraform, and Helm, refer to their official documentation.
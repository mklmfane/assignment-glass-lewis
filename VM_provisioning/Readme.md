VM Provisioning Folder Structure
-----------------------------------------------------

### Folder Structure

The folder structure for VM provisioning is organized in a modular and intuitive way to facilitate the management and understanding of the process.

**1\. cluster\_k8s\_info**

This folder contains the essential files for managing the Kubernetes cluster:

*   **Worker node join files:** These files contain the configurations necessary to join worker nodes to the Kubernetes cluster.
    
*   **admin.conf:** This file contains the credentials to connect to the Kubernetes cluster as an administrator. It is also used by Terraform for deployment within the cluster.
    

**2\. common-setup**

This folder houses the main playbook for preparing nodes, both master and worker. The playbook includes common tasks such as installing prerequisite software, configuring networking, and initializing Kubernetes services.

**3\. master-setup.yml**

This playbook is dedicated to initializing the master node. It performs the following tasks:

*   Preparing the master node using the common-setup playbook
    
*   Exporting the files contained in the \_cluster\_k8s\_info folder locally
    
*   Initializing the master node as a Kubernetes node
    

**4\. worker-setup.yaml**

This playbook is responsible for joining worker nodes to the Kubernetes cluster. It performs the following tasks:

*   Preparing worker nodes using the common-setup playbook
    
*   Joining worker nodes to the Kubernetes cluster using the join files present in the \_cluster\_k8s\_info folder
    

### Benefits of the Optimized Structure

This optimized structure offers several advantages:

*   **Modularity:** The division into separate folders facilitates the management and reuse of components.
    
*   **Clarity:** Folder and file names are descriptive, making the process more understandable.
    
*   **Maintainability:** Changes and updates are easier to implement in individual folders or files.
    
*   **Reusability:** Common playbooks can be used to prepare different types of nodes, reducing code duplication.
    

This optimized structure contributes to a more efficient, organized, and scalable VM provisioning process.
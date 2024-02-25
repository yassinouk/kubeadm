
# Booting the controlplane on kubemaster

#### after running the [`cp_node_setup.sh`](#cp_node_setup.sh) script, the controlplane will be booted on the c1-cp1 node. 

# STEPS:

## 1- Copy the kubeadm join command printed to your notepad to use on the worker nodes.

## 2- Run the copied kubeadm join command on the worker nodes.

## 3- Set up the kubeconfig so it can be used by your default user (in my case i'm already root, so will use the root option).

## 3- option 1: (if you are root) 

###   add this to your .bashrc file to make it permanent: `export KUBECONFIG=/etc/kubernetes/admin.conf` 

###   and run the following command:`source ~/.bashrc`

## 3- option 2: (if you are a regular user)

###  run the following commands:

```bash
mkdir ~/.kube                                        # Create directory for kubeconfig.
sudo cp /etc/kubernetes/admin.conf ~/.kube/config    # Copy kubeconfig file to the directory.
sudo chown $(id -u):$(id -g) ~/.kube/config          # Change ownership of kubeconfig file.
```


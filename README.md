# Kube cluster up

[OpenShift command line client](https://www.openshift.org/download.html#oc-platforms) has a nice little feature. With `oc cluster up` command you can easily bring in local OpenShift cluster using only Docker engine and nothing else. It will run OpenShift as a Docker container and provide you all important OpenShift fetarues. Unlike MiniShift it doesn't run in any virtual machine. It runs directly on your PC. That has some major advantages when you are developing software for Kubernetes. For example you share the network in which your OpenShift pods and services run. That means you can access them directly using the IP address from applications running locally. You don't have to forward ports from the Minishift machine or proxy the connection.

This project tries to create experience very similar to the one provided by `oc cluster up` but using pure Kubernetes instead of OpenShift. Currently it works, but it is not yet as nice and simple as OpenShift is.

`kube-cluster-up` currently supports only Linux OS. On MacOS X and on Windows Docker runs inside virtual machine. Therefore even when you run something similar to `oc cluster up` you will not be able to connect directly to the pods and services - and that would mean loosing the main advantage over Minishift or Minikube.

<!-- TOC depthFrom:2 -->

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Start the cluster](#start-the-cluster)
    - [Communicating with pods and services](#communicating-with-pods-and-services)
    - [Accessing Kubernetes Dashboard](#accessing-kubernetes-dashboard)
- [Stopping the cluster](#stopping-the-cluster)
- [TODO](#todo)

<!-- /TOC -->

## Prerequisites

`kube-cluster-up` currently relies on `kubeadm` and `kubelet` being installed locally. Both `kubeadm` and `kubelet` are provided as RPM and DEB packages for the most popular Linux distributions. Follow the [installation guide](https://kubernetes.io/docs/setup/independent/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl) to install them. `kube-cluster-up` uses `kubeadm` to configure and deploy other components of Kubernetes cluster. 

## Installation

To install `kube-cluster-up` you can simply clone the repository or download the release. The shell script in this repository can be placed anywhere in your system.

## Start the cluster

`kube-cluster-up` can be started by running the `kube-cluster-up.sh` script. This currently requires root privileges to configure and start some of the services. Therefore sou should call it through `sudo`:
```
sudo kube-cluster-up.sh
```

The startup script will enable and start the `kubelet` service and run `kubeadm` to configure and deploy the remainning Kubernetes services (API server, Controller, etcd, ...). Once `kubeadm` is finished, the scirpt will deploy [Calico](https://www.projectcalico.org//) network and install [Heapster](https://github.com/kubernetes/heapster) for resource monitoring and [Kubernetes Dashboard](https://github.com/kubernetes/dashboard). It will also remove labels and taints from the only node so that it can be used to schedule workloads.

`kubeconfig` file will be created in `/home/<your-username>/kubeconfig`. You can use this with `kubectl` to communicate with the cluster:
```
export KUBECONFIG=/home/<your-username>/kubeconfig
kubectl get nodes
```

You can use `kubectl` to deploy your own services.

### Communicating with pods and services

To communicate with a pod or service directly, use `kubectl` to find the IP address. Use:
```
kubectl get service -o wide
```

or:
```
kubectl get pods -o wide
```

You can use the IP adress together with the directly

### Accessing Kubernetes Dashboard

Use the method above to find the Dashboard IP address and enter it into browser:
```
kubectl get service -o wide --namespace kube-system
```

## Stopping the cluster

The cluster can be stopped using `kube-cluster-down.sh`. It will reset the kubeadm setup (stop all workloads and Kubernetes system containers) and stop the `kubelet` service.

## TODO

[ ] Run `kubelet` as docker container and not as system service
[ ] Run without `sudo`
[ ] Run without `kubeadm`

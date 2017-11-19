#!/bin/bash

set -o verbose
set -o errexit
set -o pipefail

#!/bin/bash

set -o verbose
set -o errexit
set -o pipefail
set -o nounset

# Stop services
systemctl disable kubelet
systemctl stop kubelet

# Reset Kubeadm
kubeadm reset
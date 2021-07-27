#!/bin/bash

echo Installing Kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

echo Installing MetalLB
./kustomize build ./metallb | oc apply -f -

oc adm policy add-scc-to-user privileged -n metallb-system -z speaker
echo Done!

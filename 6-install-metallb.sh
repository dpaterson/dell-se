#!/bin/bash

#vars
USER=$1
PW=$2
echo Login into cluster
oc login -u $USER -p $PW
echo Installing Kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

echo Installing MetalLB
./kustomize build ./metallb | oc apply -f -

oc adm policy add-scc-to-user privileged -n metallb-system -z speaker
echo Done!

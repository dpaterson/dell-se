#! /bin/bash

echo Creating default storage class

#vars
USER=$1
PW=$2
oc login -u $USER -p $PW
OC_VERSION=$(oc version -o yaml | grep openshiftVersion | grep -o '[0-9]*[.][0-9]*' | head -1)
FILENAME=default-storage-class.yaml
rm -f $FILENAME
cat >> $FILENAME << EOF
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: default
  annotations:
    description: default storage class
    storageclass.kubernetes.io/is-default-class: 'true'
provisioner: kubernetes.io/no-provisioner
reclaimPolicy: Delete

EOF
echo Create storage class
oc apply -f $FILENAME
echo Done!

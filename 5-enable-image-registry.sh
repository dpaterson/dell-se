#! /bin/bash

#vars
USER=$1
PW=$2
oc login -u $USER -p $PW
OC_VERSION=$(oc version -o yaml | grep openshiftVersion | grep -o '[0-9]*[.][0-9]*' | head -1)

FILENAME=image-registry-pvc.yaml

rm -f $FILENAME
cat >> $FILENAME << EOF
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: image-registry-pvc
  namespace: openshift-image-registry
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1490Gi
  storageClassName: default
  volumeMode: Filesystem

EOF
echo Create volume set
oc apply -f $FILENAME

echo Patching registry config
oc patch configs.imageregistry.operator.openshift.io/cluster --type merge -p '{"spec":{"storage":{"pvc":{"claim":"image-registry-pvc"}}}}'
oc patch configs.imageregistry.operator.openshift.io/cluster --type merge -p '{"spec":{"managementState":"Managed"}}'
oc patch configs.imageregistry.operator.openshift.io/cluster --type merge -p '{"spec":{"defaultRoute":true}}'
echo Image registry patched, Done!

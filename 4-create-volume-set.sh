#! /bin/bash

#vars
USER=$1
PW=$2
oc login -u $USER -p $PW
OC_VERSION=$(oc version -o yaml | grep openshiftVersion | grep -o '[0-9]*[.][0-9]*' | head -1)
FILENAME=local-volume-set.yaml

rm -f $FILENAME 
cat >> $FILENAME << EOF
apiVersion: local.storage.openshift.io/v1alpha1
kind: LocalVolumeSet
metadata:
  name: local-volume-set
  namespace: openshift-local-storage
spec:
  storageClassName: default 
  volumeMode: Filesystem
  fstype: ext4
  deviceInclusionSpec:
    deviceTypes: 
      - disk
      - part
  nodeSelector:
    nodeSelectorTerms:
      - matchExpressions:
          - key: kubernetes.io/hostname
            operator: In
            values:
              - r74-2-ocp-1.oss.lab2
              - r74-2-ocp-2.oss.lab2
              - r74-2-ocp-3.oss.lab2

EOF
echo Create volume set
oc apply -f $FILENAME
echo Done!

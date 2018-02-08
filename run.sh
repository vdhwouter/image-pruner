#!/bin/bash

keep_complete=${KEEP_COMPLETE:-5}
keep_failed=${KEEP_FAILED:-1}
keep_tags=${KEEP_TAGS:-5}
keep_younger=${KEEP_YOUNGER:-24h}

# only needed for writing a kubeconfig:
master_url=${MASTER_URL:-https://kubernetes.default.svc.cluster.local:443}
master_ca=${MASTER_CA:-/var/run/secrets/kubernetes.io/serviceaccount/ca.crt}
token_file=${TOKEN_FILE:-/var/run/secrets/kubernetes.io/serviceaccount/token}
project=${PROJECT:-default}


# set up configuration for openshift client
if [ -n "${WRITE_KUBECONFIG}" ]; then
    # craft a kubeconfig, usually at $KUBECONFIG location
    oc config set-cluster master \
  --api-version='v1' \
  --certificate-authority="${master_ca}" \
  --server="${master_url}"
    oc config set-credentials account \
  --token="$(cat ${token_file})"
    oc config set-context current \
  --cluster=master \
  --user=account \
  --namespace="${project}"
    oc config use-context current
fi

#prune images 
oc adm prune images \
--keep-tag-revisions=$keep_tags \
--keep-younger-than=$keep_younger

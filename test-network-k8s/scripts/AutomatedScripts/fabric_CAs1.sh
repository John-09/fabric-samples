#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

function launch_ECert_CAs() {
  push_fn "Launching Fabric CAs"

#   apply_template kube/org0/org0-ca.yaml $ORG0_NS
#   apply_template kube/org1/org1-ca.yaml $ORG1_NS
#   apply_template kube/org2/org2-ca.yaml $ORG2_NS
  apply_template ${NAMESPACE}/kube/${ORG_NAME}orderer/${ORG_NAME}orderer-ca.yaml $NAMESPACE
  apply_template ${NAMESPACE}/kube/${ORG_NAME}/${ORG_NAME}-ca.yaml ${NAMESPACE}


#   kubectl -n $ORG1_NS rollout status deploy/org1-ca
#   kubectl -n $ORG2_NS rollout status deploy/org2-ca
#   kubectl -n $ORG3_NS rollout status deploy/org3-ca
  kubectl -n ${NAMESPACE} rollout status deploy/${ORG_NAME}orderer-ca
  kubectl -n ${NAMESPACE} rollout status deploy/${ORG_NAME}-ca

  # todo: this papers over a nasty bug whereby the CAs are ready, but sporadically refuse connections after a down / up
  sleep 5

  pop_fn
}

# experimental: create TLS CA issuers using cert-manager for each org.
function init_tls_cert_issuers() {
  push_fn "Initializing TLS certificate Issuers"

  # Create a self-signing certificate issuer / root TLS certificate for the blockchain.
  # TODO : Bring-Your-Own-Key - allow the network bootstrap to read an optional ECDSA key pair for the TLS trust root CA.
#   kubectl -n $ORG0_NS apply -f kube/root-tls-cert-issuer.yaml
#   kubectl -n $ORG0_NS wait --timeout=30s --for=condition=Ready issuer/root-tls-cert-issuer
#   kubectl -n $ORG1_NS apply -f kube/root-tls-cert-issuer.yaml
#   kubectl -n $ORG1_NS wait --timeout=30s --for=condition=Ready issuer/root-tls-cert-issuer
#   kubectl -n $ORG2_NS apply -f kube/root-tls-cert-issuer.yaml
#   kubectl -n $ORG2_NS wait --timeout=30s --for=condition=Ready issuer/root-tls-cert-issuer
#   kubectl -n $ORG3_NS apply -f kube/root-tls-cert-issuer.yaml
#   kubectl -n $ORG3_NS wait --timeout=30s --for=condition=Ready issuer/root-tls-cert-issuer
  kubectl -n ${NAMESPACE} apply -f kube/root-tls-cert-issuer.yaml
  kubectl -n ${NAMESPACE} wait --timeout=30s --for=condition=Ready issuer/root-tls-cert-issuer

  # Use the self-signing issuer to generate three Issuers, one for each org.

#   kubectl -n $ORG1_NS apply -f kube/org1/org1-tls-cert-issuer.yaml
#   kubectl -n $ORG2_NS apply -f kube/org2/org2-tls-cert-issuer.yaml
#   kubectl -n $ORG3_NS apply -f kube/org3/org3-tls-cert-issuer.yaml
  kubectl -n ${NAMESPACE} apply -f ${NAMESPACE}/kube/${ORG_NAME}orderer/${ORG_NAME}orderer-tls-cert-issuer.yaml
  kubectl -n ${NAMESPACE} apply -f ${NAMESPACE}/kube/${ORG_NAME}/${ORG_NAME}-tls-cert-issuer.yaml

#   kubectl -n $ORG0_NS wait --timeout=30s --for=condition=Ready issuer/org0-tls-cert-issuer
#   kubectl -n $ORG1_NS wait --timeout=30s --for=condition=Ready issuer/org1-tls-cert-issuer
#   kubectl -n $ORG2_NS wait --timeout=30s --for=condition=Ready issuer/org2-tls-cert-issuer
  kubectl -n ${NAMESPACE} wait --timeout=30s --for=condition=Ready issuer/${ORG_NAME}orderer-tls-cert-issuer
  kubectl -n ${NAMESPACE} wait --timeout=30s --for=condition=Ready issuer/${ORG_NAME}-tls-cert-issuer

  pop_fn
}

function enroll_bootstrap_ECert_CA_user() {
  local org=$1
  local ns=$2

  # Determine the CA information and TLS certificate
  CA_NAME=${org}-ca
  CA_DIR=${TEMP_DIR}/cas/${CA_NAME}
  mkdir -p ${CA_DIR}

  # Read the CA's TLS certificate from the cert-manager CA secret
  echo "retrieving ${CA_NAME} TLS root cert"
  kubectl -n $ns get secret ${CA_NAME}-tls-cert -o json \
    | jq -r .data.\"ca.crt\" \
    | base64 -d \
    > ${CA_DIR}/tlsca-cert.pem

  # Enroll the root CA user
  fabric-ca-client enroll \
    --url https://${RCAADMIN_USER}:${RCAADMIN_PASS}@${CA_NAME}.${DOMAIN}:${NGINX_HTTPS_PORT} \
    --tls.certfiles $TEMP_DIR/cas/${CA_NAME}/tlsca-cert.pem \
    --mspdir $TEMP_DIR/enrollments/${org}/users/${RCAADMIN_USER}/msp
}

function enroll_bootstrap_ECert_CA_users() {
  push_fn "Enrolling bootstrap ECert CA users"

#   enroll_bootstrap_ECert_CA_user org0 $ORG0_NS
#   enroll_bootstrap_ECert_CA_user org1 $ORG1_NS
#   enroll_bootstrap_ECert_CA_user org2 $ORG2_NS
  enroll_bootstrap_ECert_CA_user ${ORG_NAME}orderer ${NAMESPACE}
  enroll_bootstrap_ECert_CA_user ${ORG_NAME} ${NAMESPACE}

  pop_fn
}
#Orderer setup files
#config/Org Orderer

updated_dir="/workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/config/${ORG_NAME}-orderer"
mkdir -p "$updated_dir"
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/configtx-template.yaml > /workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/config/${ORG_NAME}-orderer/configtx-template.yaml
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/orderer/fabric-ca-server-config.yaml > /workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/config/${ORG_NAME}-orderer/fabric-ca-server-config.yaml
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/orderer.yaml > /workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/config/${ORG_NAME}-orderer/orderer.yaml

#config/org files

updated_dir="/workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/config/${ORG_NAME}"
mkdir -p "$updated_dir"
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/core.yaml > /workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/config/${ORG_NAME}/core.yaml
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/fabric-ca-server-config.yaml > /workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/config/${ORG_NAME}/fabric-ca-server-config.yaml

#Duplicate config for channel creation

updated_dir="/workspaces/fabric-samples/test-network-k8s/config/${ORG_NAME}"
mkdir -p "$updated_dir"
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/core.yaml > /workspaces/fabric-samples/test-network-k8s/config/${ORG_NAME}/core.yaml
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/fabric-ca-server-config.yaml > /workspaces/fabric-samples/test-network-k8s/config/${ORG_NAME}/fabric-ca-server-config.yaml

#Orderer pvc-fabric-org.yaml

awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/orderer-pvc-fabric.yaml > /workspaces/fabric-samples/test-network-k8s/kube/pvc-fabric-${ORG_NAME}orderer.yaml

# kube/pvc-fabric-org.yaml

awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/pvc-fabric-org.yaml > /workspaces/fabric-samples/test-network-k8s/kube/pvc-fabric-${ORG_NAME}.yaml

#Kube/orderer yaml files
# ca file
updated_dir="/workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/kube/${ORG_NAME}orderer"
mkdir -p "$updated_dir"
# updated_file="/workspaces/fabric-samples/test-network-k8s/kube/${ORG_NAME}/-tls-cert-issuer.yaml"
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/orderer/orderer-ca.yaml > /workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/kube/${ORG_NAME}orderer/${ORG_NAME}orderer-ca.yaml

#job-scrub-fabric-volume
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/orderer/orderer-job-scrub-fabric-volumes.yaml > /workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/kube/${ORG_NAME}orderer/${ORG_NAME}orderer-job-scrub-fabric-volumes.yaml

#orderer1.yaml
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/orderer/orderer-orderer1.yaml > /workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/kube/${ORG_NAME}orderer/${ORG_NAME}orderer-orderer1.yaml

#orderer-tls-crt
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/orderer/orderer-tls-cert-issuer.yaml > /workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/kube/${ORG_NAME}orderer/${ORG_NAME}orderer-tls-cert-issuer.yaml


# kube/org/yaml files
# ca file
updated_dir="/workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/kube/${ORG_NAME}"
mkdir -p "$updated_dir"
# updated_file="/workspaces/fabric-samples/test-network-k8s/kube/${ORG_NAME}/-tls-cert-issuer.yaml"
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/org-ca.yaml > /workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/kube/${ORG_NAME}/${ORG_NAME}-ca.yaml

#CC template file
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/org-cc-template.yaml > /workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/kube/${ORG_NAME}/${ORG_NAME}-cc-template.yaml

#k8s builder file
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/org-install-k8s-builder.yaml > /workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/kube/${ORG_NAME}/${ORG_NAME}-install-k8s-builder.yaml

#job scrub fabric volume file
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/org-job-scrub-fabric-volumes.yaml > /workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/kube/${ORG_NAME}/${ORG_NAME}-job-scrub-fabric-volumes.yaml

#org peer1 file
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/org-peer1.yaml > /workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/kube/${ORG_NAME}/${ORG_NAME}-peer1.yaml

#org peer2 file
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/org-peer2.yaml > /workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/kube/${ORG_NAME}/${ORG_NAME}-peer2.yaml

#org tls cer issuer file
updated_file="/workspaces/fabric-samples/test-network-k8s/${ORG_NAME}-Network/kube/${ORG_NAME}/${ORG_NAME}-tls-cert-issuer.yaml"
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/org-tls-cert-issuer.yaml > "$updated_file"

#Updating channel yaml file

# awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/configtx-template1.yaml > /workspaces/fabric-samples/test-network-k8s/config/org0/configtx-template1.yaml
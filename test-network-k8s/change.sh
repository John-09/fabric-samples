# config/core.yaml

updated_dir="/workspaces/fabric-samples/test-network-k8s/config/${ORG_NAME}"
mkdir -p "$updated_dir"
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/core.yaml > /workspaces/fabric-samples/test-network-k8s/config/${ORG_NAME}/core.yaml
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/fabric-ca-server-config.yaml > /workspaces/fabric-samples/test-network-k8s/config/${ORG_NAME}/fabric-ca-server-config.yaml

# kube/pvc-fabric-org.yaml

awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/pvc-fabric-org.yaml > /workspaces/fabric-samples/test-network-k8s/kube/pvc-fabric-org.yaml

# kube/org/yaml files

# ca file
updated_dir="/workspaces/fabric-samples/test-network-k8s/kube/${ORG_NAME}"
mkdir -p "$updated_dir"
# updated_file="/workspaces/fabric-samples/test-network-k8s/kube/${ORG_NAME}/-tls-cert-issuer.yaml"
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/org-ca.yaml > /workspaces/fabric-samples/test-network-k8s/kube/${ORG_NAME}/org-ca.yaml

#CC template file
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/org-cc-template.yaml > /workspaces/fabric-samples/test-network-k8s/kube/${ORG_NAME}/org-cc-template.yaml

#k8s builder file
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/org-install-k8s-builder.yaml > /workspaces/fabric-samples/test-network-k8s/kube/${ORG_NAME}/org-install-k8s-builder.yaml

#job scrub fabric volume file
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/org-job-scrub-fabric-volumes.yaml > /workspaces/fabric-samples/test-network-k8s/kube/${ORG_NAME}/${ORG_NAME}-job-scrub-fabric-volumes.yaml

#org peer1 file
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/org-peer1.yaml > /workspaces/fabric-samples/test-network-k8s/kube/${ORG_NAME}/org-peer1.yaml

#org peer2 file
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/org-peer2.yaml > /workspaces/fabric-samples/test-network-k8s/kube/${ORG_NAME}/org-peer2.yaml

#org tls cer issuer file
updated_file="/workspaces/fabric-samples/test-network-k8s/kube/${ORG_NAME}/${ORG_NAME}-tls-cert-issuer.yaml"
awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/org/org-tls-cert-issuer.yaml > "$updated_file"

#Updating channel yaml file

awk -v org_name="$ORG_NAME" '{gsub(/XYZ/, org_name)}1' /workspaces/fabric-samples/test-network-k8s/predefinedOrg/configtx-template1.yaml > /workspaces/fabric-samples/test-network-k8s/config/org0/configtx-template1.yaml
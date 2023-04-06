function stop_services() {
  push_fn "Stopping Fabric services"
  for ns in ${NAMESPACE}; do
    kubectl -n $ns delete ingress --all
    kubectl -n $ns delete deployment --all
    kubectl -n $ns delete pod --all
    kubectl -n $ns delete service --all
    kubectl -n $ns delete configmap --all
    kubectl -n $ns delete cert --all
    kubectl -n $ns delete issuer --all
    kubectl -n $ns delete secret --all
  done

  pop_fn
}

function scrub_org_volumes() {
  push_fn "Scrubbing Fabric volumes"
  for org in ${ORG_NAME}; do
    # clean job to make this function can be rerun
    local namespace_variable=${org^^}_NS
    kubectl -n ${!namespace_variable} delete jobs --all

    # scrub all pv contents
    kubectl -n ${!namespace_variable} create -f kube/${org}/${org}-job-scrub-fabric-volumes.yaml
    kubectl -n ${!namespace_variable} wait --for=condition=complete --timeout=60s job/job-scrub-fabric-volumes
    kubectl -n ${!namespace_variable} delete jobs --all
  done
  pop_fn
}

function network_down() {

  set +e
  for ns in ${NAMESPACE}; do
    kubectl get namespace $ns > /dev/null
    if [[ $? -ne 0 ]]; then
      echo "No namespace $ns found - nothing to do."
      return
    fi
  done
  set -e

  stop_services
  scrub_org_volumes

  delete_namespace

  rm -rf $PWD/build/cas/${ORG_NAME}-ca
  rm -rf $PWD/build/enrollments/${ORG_NAME}

}
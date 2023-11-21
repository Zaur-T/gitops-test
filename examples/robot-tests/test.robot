*** Settings ***
Library           BuiltIn
Library           yaml
Library           Collections
Library           OperatingSystem
Library           RequestsLibrary
Library           Telnet
Library           String
Library           KubeLibrary    incluster=true


*** Variables ***
${NAMESPACE}         argocd

*** Test Cases ***

# checking basic k8s obkects are healthy in certmanager nsecret

check deployments
    Given namespace with the name "${NAMESPACE}" exists
    When list of all deployments in "${NAMESPACE}" namespace

*** Keywords ***

namespace with the name "${namespace}" exists
    KubeLibrary.get    api_version=v1        kind=Namespace    name=${namespace}
    Log    \nNamespace "${namespace}" exist!  console=True

list of all deployments in "${namespace}" namespace
    @{namespace_deployments}=  list_namespaced_deployment_by_pattern    .*  ${namespace}
    Log  \nDeployments in namespace ${namespace}:  console=True
    FOR  ${deployment}  IN  @{namespace_deployments}
        Log   "${deployment.metadata.name}"  console=True
    END

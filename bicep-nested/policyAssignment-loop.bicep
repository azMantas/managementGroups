targetScope = 'managementGroup'

param policies object
param environment string = ''
param location string = ''
param policyIdentityResourceId string

var formatPolicies = [for item in items(policies.scope):{
  scope: item.key
  param: item.value.parameters
  mode: item.value.enforcementMode
  name: policies.policyName
  display: policies.policyDisplayName
  id: policies.policyDefinitionId
}]


module assignmentNested '../bicep-base/policyAssignments.bicep' = [for item in formatPolicies: {
  scope: managementGroup('${item.scope}-${environment}')
  params: {
    name: item.name
    definitionId: item.id
    displayName: item.display
    parameters: item.param
    policyIdentityResourceId: policyIdentityResourceId
    location: location
  }
}]

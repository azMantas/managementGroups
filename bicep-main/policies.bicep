targetScope = 'managementGroup'

#disable-next-line no-unused-params
param topLevelManagementGroupName string
param definitions array
param setDefinitions array
param policyAssignments array
param environment string
param location string
param policyIdentityResourceId string = ''

// param utc string = utcNow()
// var uniqueValue = take(uniqueString(utc), 5)

@batchSize(20)
module definitionDeployment '../bicep-base/policyDefinitions.bicep' = [
  for item in definitions: {
    name: 'definition-${item.name}'
    params: {
      policyName: item.name
      policyProperties: item.properties
    }
  }
]

@batchSize(20)
module setDefinitionDeployment '../bicep-base/policySetDefinitions.bicep' = [
  for item in setDefinitions: {
    name: 'setDefinition-${item.name}'
    dependsOn: definitionDeployment
    params: {
      policySetDefinitionName: item.name
      policySetDefinitionProperties: item.properties
    }
  }
]

module assignmentDeployment '../bicep-nested/policyAssignment-loop.bicep' = [
  for item in policyAssignments: {
    dependsOn: setDefinitionDeployment
    name: 'policy-${item.policyName}'
    params: {
      policies: item
      environment: environment
      policyIdentityResourceId: policyIdentityResourceId
      location: location
    }
  }
]

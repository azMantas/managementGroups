using '../bicep-main/roleAssignments.bicep'
import * as func from '../bicep-base/functions.bicep'

param environment = ''

var rbacMapping = loadJsonContent('mappingRbac.json')
var customRoles = loadJsonContent('customRoles.json')
var entraId = loadJsonContent('mappingEntraId.json')

param rbac = {
  gazelle: [
    {
      roleDefinitionId: func.customRoleDefinitionId(customRoles.platformEngineers.name, environment)
      principalId: [
        entraId.AzurePlatformEngineers
      ]
    }
  ]
  platform: [
    {
      roleDefinitionId: rbacMapping.Contributor
      principalId: [
        entraId.AzurePlatformEngineers
      ]
    }
  ]
}

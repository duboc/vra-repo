function handler($context, $payload) {

    $oldVMName = $payload.resourceNames[0]
    $newVMName = $payload.customProperties.userDefinedName

    $returnObj = [PSCustomObject]@{
        resourceNames       = $payload.resourceNames
    }
    $returnObj.resourceNames[0] = $newVMName

    Write-Host "Setting machine name from $($oldVMName) to $($newVMName)"

    return $returnObj
}

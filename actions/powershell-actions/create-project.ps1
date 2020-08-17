function handler($context, $payload) {
    
    $body = @{
        name = $payload.projectName
        description = "i am a new project"
    }
    
    $resp = $context.request("/project-service/api/projects", "POST", (ConvertTo-Json $body))
    Write-Host $resp.Content
    Write-Host $resp.StatusCode
    
    return $payload
}

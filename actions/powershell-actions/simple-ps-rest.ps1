function handler($context, $payload) {
  Write-Host "Hello " $payload.target
  
  $uri = $payload.url
  $response = Invoke-RestMethod -Uri $uri 
  Write-Host $response
   
  return $payload
}


Import-Module DnsServer
function handler($context) {
$zoneName="jonsdomains.local"
$name="vrapoctest1"
$ipAddress="192.168.200.245"
$dnsServer="192.168.1.100"
Add-DnsServerResourceRecordA -ZoneName $zoneName -Name $name -IPAddress $ipAddress -ComputerName $dnsServer 
Write-Progress -Activity "Retrieving members..." -Completed

}


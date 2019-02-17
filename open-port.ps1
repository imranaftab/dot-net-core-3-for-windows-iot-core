param([int] $port = -1)
# If port number is not supplied in command-line arugment then ask for port number
while(-NOT ($port -ge 1 -AND $port -le 65535)){
    $port = [int] (Read-Host "Enter Port to Open")
    if($port -ge 1 -AND $port -le 65535){
        $isValidPort = $true;
    } else{
        Write-Host "$($port) is not a invalid port number."
    }
} 
netsh advfirewall firewall add rule name=”ASP.NET Core Web Server port” dir=in action=allow protocol=TCP localport=$port

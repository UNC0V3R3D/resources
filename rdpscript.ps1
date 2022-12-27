# Store the registry keys in variables for easier reuse
$terminalServerKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server'
$rdpTcpKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp'

# Store the firewall rule groups in variables for easier reuse
$remotefxRuleGroup = 'remote desktop - remotefx'
$remoteDesktopRuleGroup = 'remote desktop'

# Check the current value of the fDenyTSConnections property
$currentFDenyTSConnections = Get-ItemProperty -Path $terminalServerKey -Name fDenyTSConnections

# Set the value of the fDenyTSConnections property to 0 if it is not already set to that value
if ($currentFDenyTSConnections -ne 0) {
    Set-ItemProperty -Path $terminalServerKey -Name fDenyTSConnections -Value 0
}

# Check the current value of the UserAuthentication property
$currentUserAuthentication = Get-ItemProperty -Path $rdpTcpKey -Name UserAuthentication

# Set the value of the UserAuthentication property to 1 if it is not already set to that value
if ($currentUserAuthentication -ne 1) {
    Set-ItemProperty -Path $rdpTcpKey -Name UserAuthentication -Value 1
}

# Enable the firewall rule group for Remote Desktop - RemoteFX
Set-NetFirewallRule -Group $remotefxRuleGroup -Enabled True

# Enable the firewall rule group for Remote Desktop
Set-NetFirewallRule -Group $remoteDesktopRuleGroup -Enabled True

# Exit the PowerShell interpreter
exit
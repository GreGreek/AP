[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
New-Item -Type Directory -Path "C:\HWID"
Set-Location -Path "C:\HWID"
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"

Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned

Install-Script -Name Get-WindowsAutopilotInfo -Force

# Get the serial number of the computer
$serialNumber = (Get-WmiObject -Class Win32_BIOS).SerialNumber

# Generate filename based on serial number or Intune device name
if ($serialNumber -ne $null) {
    $filename = "AutopilotHWID_$serialNumber.csv"
} else {
    $filename = "AutopilotHWID.csv"
}

# Prompt the user to enter the GroupTag
$groupTag = Read-Host -Prompt "Please enter the GroupTag"

Get-WindowsAutopilotInfo -OutputFile $filename -GroupTag $groupTag

# Open the CSV file in Notepad
Start-Process -FilePath "notepad.exe" -ArgumentList "$filename"

# Copy the contents to the clipboard
Get-Content -Path "$filename" | Set-Clipboard

# This script disables PowerShell scripts.

# Get the list of all PowerShell scripts.
$scripts = Get-ChildItem -Path "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\Microsoft.PowerShell.Utility\Scripts\*.ps1"

# Disable the PowerShell scripts.
foreach ($script in $scripts) {
    # Get the script's execution policy.
    $executionPolicy = Get-ExecutionPolicy -Path $script.FullName

    # Set the script's execution policy to "Restricted".
    Set-ExecutionPolicy -Path $script.FullName -ExecutionPolicy Restricted
}

# Write a message to the console.
Write-Host "PowerShell scripts have been disabled."

Write-Host "PROFILE CLEARNER SCRIPT"
Write-Host "Created by Sebastian Opiyo - This is version 3 of the script"
Write-Host "To Report Bugs, Contact: sebamopale@gmail.com"
Write-Host "*************************************************************"
Write-Host ""

Write-Host "DELETE USER PROFILE FILES"
Write-Host "Be careful with your choices, this can break the machine!"
Write-Host "**********************************************************"
Write-Host ""

# Add error handling to the script.
$ErrorActionPreference = "Stop"

# Define the list of excluded user profiles.
$excludedProfiles = @(
    "OracleOraDB18Home1MTSRecoveryService",
    "MSSQL$SQLEXPRESS",
    "OracleVssWriterXE",
    "ksnproxy",
    "OracleOraDB18Home1TNSListener",
    "SQLTELEMETRY$SQLEXPRESS",
    "OracleServiceXE",
    "Admin",
    "labz",
    "freshman",
    "freshman2",
    "saopiyo",
    "Labz",
    "Administrator",
    "kasp@usiu.ac.ke",
    "NetworkService",
    "LocalService",
    "systemprofile"
)

# Function to delete profile and hive keys.
function DeleteUserProfileAndHiveKeys($profile) {
    $profileName = $profile.LocalPath.Substring($profile.LocalPath.LastIndexOf("\") + 1)
    $profilePath = $profile.LocalPath
  
    # Check if excluded.
    if ($excludedProfiles -contains $profileName) {
        Write-Host "Skipping profile '$profileName' because it is excluded."
        return
    }
  
    # Delete the profile directory.
    Write-Host "Deleting profile '$profileName'..."
    try {
        Remove-Item -Path $profilePath -Force -Recurse -ErrorAction SilentlyContinue
    } catch {
        Write-Host "Error deleting profile '$profileName': $($_.Exception.Message)"
    }
  
    # Delete the corresponding registry key.
    Write-Host "Deleting registry key for profile '$profileName'..."
    try {
        $sid = $profile.SID
        $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$sid"
        Remove-Item -Path $registryPath -Force -ErrorAction Stop
    } catch {
        Write-Host "Error deleting registry key for profile '$profileName': $($_.Exception.Message)"
    }
}

# List existing user profiles.
Write-Host "Existing User Profiles:"
Write-Host "-----------------------"
Get-WmiObject -Class Win32_UserProfile | Select-Object LocalPath, SID | ForEach-Object { Write-Host " - $($_.LocalPath) (SID: $($_.SID))" }

# Process each profile.
foreach ($profile in Get-WmiObject -Class Win32_UserProfile) {
    DeleteUserProfileAndHiveKeys $profile
}

# List remaining user profiles.
Write-Host "Remaining User Profiles:"
Write-Host "-----------------------"
Get-WmiObject -Class Win32_UserProfile | Select-Object LocalPath, SID | ForEach-Object { Write-Host " - $($_.LocalPath) (SID: $($_.SID))" }

Write-Host "Script completed successfully."
Write-Host "Molto grazie!"

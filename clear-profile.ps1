# This script lists existing user profiles and prompts the user to delete them.
# It also exempts the profiles that are specified in the `exemptedProfiles` list.

Write-Host "**************** ------- *****************"
Write-Host "**************** AUTHOR ******************"
Write-Host "-*-*- Yours Truly: Sebastian Opiyo-*-*-*-*"
Write-Host "-*-*- Version 2 on 14Th Aug, 2023. -*-*-*-"
Write-Host "**************** ------- *****************"
Write-Host ""
Write-Host ""

# Get all user profiles.
$profiles = Get-WmiObject -Class Win32_UserProfile

# Get the list of exempted profiles.
$exemptedProfiles = @("Admin", "Labz", "Administrator", "LocalService", "systemprofile", "NetworkService")

# Filter the profiles array to only include user profiles that are not currently in use.
$profiles = $profiles | Where-Object {$_.LocalPath -ne $env:USERPROFILE}

# Print the profile names
Write-Host ""
Write-Host "**************** PROFILES*****************"
Write-Host "**************** EXISTING NAMES*****************"
Write-Host "Existing User profile Names:"
Write-Host ""
foreach ($profile in $profiles) {
    # Get the profile name from the profile path.
    $profileName = $profile.LocalPath.Substring($profile.LocalPath.LastIndexOf("\") + 1)

    # Print the profile name.
    Write-Host "User profile: $profileName"
}

# List the user profiles.
Write-Host ""
Write-Host "**************** Paths*****************"
Write-Host "User Profile Path"
Write-Host ""
foreach ($profile in $profiles) {
    # Exclude the currently logged in profile.
    if ($profile.LocalPath -ne $env:USERPROFILE) {
        # Exclude the exempted profiles.
        if ($profile.Name -notin $exemptedProfiles) {
            Write-Host "User profile: $($profile.LocalPath)"
        }
    }
}

# Prompt the user to delete the user profiles.
Write-Host ""
$confirm = Read-Host "Do you want to delete the user profiles? (Y/N)"

# Delete the user profiles if the user confirms.
if ($confirm -eq "Y") {
    $deletedProfiles = @()

    Write-Host "START USER PROFILE DELETION!"

    foreach ($profile in $profiles) {
        # Exclude the currently logged in profile.
        if ($profile.LocalPath -ne $env:USERPROFILE) {
            # Exclude the exempted profiles and the Admin profile.
            if ($profile.Name -notin $exemptedProfiles -and $profile.Name -ne "Admin") {
                # Delete the user profile directory.
                $profilePath = $profile.LocalPath
                Remove-Item -Path $profilePath -Force -Recurse
                $deletedProfiles += $profilePath
                Write-Host "Deleted user profile directory: $profilePath"

                # Clear the user profile object in the registry.
                $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$($profile.Name)"
                Remove-Item -Path $registryPath
            }
        }
    }

    # Refresh the profiles array after deleting profiles.
    $profiles = Get-WmiObject -Class Win32_UserProfile

    if ($deletedProfiles.Count -gt 0) {
        Write-Host ""
        Write-Host "Deletion of user profiles is complete."
    } else {
        Write-Host ""
        Write-Host "No user profiles were deleted."
    }
}

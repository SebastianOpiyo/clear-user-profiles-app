# This script lists existing user profiles and prompts the user to delete them.
# It also exempts the profiles that are specified in the `exemptedProfiles` list.

Write-Host "**************** ------- *****************"
Write-Host "**************** AUTHOR ******************"
Write-Host "-*-*- Yours Truly: Sebastian Opiyo-*-*-*-*"
Write-Host "-*-*- Version 2 on 14Th Aug, 2023. -*-*-*-"
Write-Host "**************** ------- *****************"
Write-Host ""
Write-Host ""

# Get the list of user profiles.
$profiles = Get-WmiObject -Class Win32_UserProfile

# Print the list of user profiles.
foreach ($profile in $profiles) {
    $profileName = $profile.LocalPath.Substring($profile.LocalPath.LastIndexOf("\") + 1)

    Write-Host "User profile: $($profileName)"
}

# Prompt the user to delete the user profiles.
$confirm = Read-Host "Do you want to delete the user profiles? (Y/N)"

# Delete the user profiles if the user confirms.
if ($confirm -eq "Y") {
    foreach ($profile in $profiles) {
        # Get the path to the user profile directory.
        $profilePath = $profile.LocalPath

        # Prompt the user to confirm the deletion of the user profile directory.
        $confirmDelete = Read-Host "Do you want to delete the user profile directory '$profilePath'? (Y/N)"

        # Delete the user profile directory if the user confirms.
        if ($confirmDelete -eq "Y") {
            Remove-Item -Path $profilePath -Force

            $profileName = $profile.LocalPath.Substring($profile.LocalPath.LastIndexOf("\") + 1)

            # Print the profile name
            Write-Host "User profile: $($profileName)"

            # Delete the registry key.
            $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$($profileName)"
            Remove-Item -Path $registryPath
        }
    }
}


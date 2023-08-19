# This script lists existing user profiles and prompts the user to delete them.
# It also exempts the profiles that are specified in the `exemptedProfiles` list.

Write-Host "**************** ------- *****************"
Write-Host "**************** AUTHOR ******************"
Write-Host "-*-*- Yours Truly: Sebastian Opiyo-*-*-*-*"
Write-Host "-*-*- Version 2 on 14Th Aug, 2023. -*-*-*-"
Write-Host "**************** ------- *****************"
Write-Host ""
Write-Host ""

Write-Host "PROFILE CLEARNER SCRIPT"
Write-Host "Created by Sebastian Opiyo - This is version 3 of the script"
Write-Host "To Report Bugs, Contact: sebamopale@gmail.com"
Write-Host "*************************************************************"

Write-Host ""

Write-Host "DELETE USER PROFILE FILES"
Write-Host "Be careful with your choices, this can break the machine!"
Write-Host "**********************************************************"

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
        $profileSID = $profile.SID

        # Prompt the user to confirm the deletion of the user profile directory.
        $confirmDelete = Read-Host "Do you want to delete the user profile directory '$profilePath'? (Y/N)"
        Write-Host "User profile SID: $($profileName)"

        # Delete the user profile directory if the user confirms.
        if ($confirmDelete -eq "Y") {
            Remove-Item -Path $profilePath -Force
            Write-Host "Path to user profile deleted successfuly."
        }
    }
}


# DELETE THE CORESPONDING CONTENTS IN THE REGISTRY
# This script lists user profiles in the registry and asks for confirmation before deleting any profile.
# It also deletes the profile permanently in the registry.
Write-Host ""

Write-Host "WE TOUCH THE HEART, THE HIVE"
Write-Host "Be careful with your choices, this can break the machine!"
Write-Host "**********************************************************"

# Get the list of user profiles.
$profiles = Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" | Select-Object

# Print the list of names and ProfileImagePath.
# Print the list of names and ProfileImagePath.
foreach ($hiveKey in $profiles) {
    $profileImagePath = (Get-ItemProperty -Path ("HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\" + $hiveKey.PSChildName)).ProfileImagePath
    Write-Host "Name: $($hiveKey.PSChildName)"
    Write-Host "ProfileImagePath: $profileImagePath"

    # Prompt the user to confirm the deletion of the registry key.
    $confirmDelete = Read-Host "Do you want to delete the registry key '$($hiveKey.PSChildName)'? (Y/N)"

    # Delete the registry key if the user confirms.
    if ($confirmDelete -eq "Y") {
        Remove-Item -Path ("HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\" + $hiveKey.PSChildName) -Force
    }
}

Write-Host ""

Write-Host "*****END OF SCRIPT****"

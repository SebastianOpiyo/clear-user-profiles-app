# This script lists existing user profiles and prompts the user to delete them.
# It also exempts the profiles that are specified in the `exemptedProfiles` list.

# Get all user profiles.
$profiles = GetWmiObject -Class Win32_UserProfile

# Get the list of exempted profiles.
$exemptedProfiles = @("LocalService", "systemprofile", "NetworkService")

# List the user profiles.
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
$confirm = Read-Host "Do you want to delete the user profiles? (Y/N)"

# Delete the user profiles if the user confirms.
if ($confirm -eq "Y") {
    foreach ($profile in $profiles) {
        # Exclude the currently logged in profile.
        if ($profile.LocalPath -ne $env:USERPROFILE) {
            # Exclude the exempted profiles.
            if ($profile.Name -notin $exemptedProfiles) {
                # Delete the user profile.
                $profile.Delete($profile.LocalPath)
                Write-Host "Deleted user profile $($profile.LocalPath)"
            }
        }
    }
}

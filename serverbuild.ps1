$Drive = "D:"

# uri LOF package Server 2022
$uri = "https://go.microsoft.com/fwlink/p/?linkid=2195333"

# download LOF package iso
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $uri -OutFile "$Drive\lang.iso"

#mount LOF
$mountedImage = Mount-DiskImage -ImagePath "$Drive\lang.iso"

# Get the volume information
$volumeInfo = $mountedImage | Get-Volume

# Extract the drive letter
$driveLetter = $volumeInfo.DriveLetter

cmd /c lpksetup /i fr-fr /p "$($driveLetter):\LanguagesAndOptionalFeatures\"

#variables
$regionalsettingsURL = "https://raw.githubusercontent.com/alexcailyer/azure/main/CARegion.xml"
$RegionalSettings = "$Drive\CARegion.xml"


#download regional settings file
$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($regionalsettingsURL,$RegionalSettings)


# Set Locale, language etc. 
& $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"$RegionalSettings`""

# Set languages/culture. Not needed perse.
Set-WinSystemLocale fr-CA
Set-WinUserLanguageList -LanguageList fr-FR -Force
Set-Culture -CultureInfo fr-FR
Set-WinHomeLocation -GeoId 39
Set-TimeZone -Name "Eastern Standard Time"

# restart virtual machine to apply regional settings to current user. You could also do a logoff and login.
Start-sleep -Seconds 40
Restart-Computer

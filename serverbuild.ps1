# Script to define regional settings on Azure Virtual Machines deployed from the market place
# Author: Alexandre Verkinderen
# Blogpost: https://mscloud.be/configure-regional-settings-and-windows-locales-on-azure-virtual-machines/
#
######################################

Get-WindowsCapability -Online | Where-Object {$_.Name -like "Language.Basic~~~fr-FR~*"}

#variables
$regionalsettingsURL = "https://raw.githubusercontent.com/alexcailyer/azure/main/CARegion.xml"
$RegionalSettings = "D:\CARegion.xml"


#downdload regional settings file
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

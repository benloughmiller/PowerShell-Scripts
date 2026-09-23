#Automatically installs the latest 7-Zip version. This script can be ran as a scheduled task

#Script variables
$downloadPageUrl = "https://www.7-zip.org/download.html"
$installerPath = "$env:TEMP\7zip-installer.exe"

try {
    #Finds the download url for the latest X64 installer 
    $downloadPageContent = Invoke-WebRequest -Uri $downloadPageUrl
    $downloadUrl = $downloadPageContent.Links | Where-Object { $_.href -match "a/7z\d+-x64.exe" } | Select-Object -ExpandProperty href -First 1
    $downloadUrl = "https://www.7-zip.org/$downloadUrl"

    #Downloads the installer file from the found URL
    Write-Host "Downloading 7-Zip from $downloadUrl..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath

    #Installs 7-Zip Silently
    Write-Host "Installing 7-Zip..."
    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
    
    #Deletes Installer file
    Remove-Item -Path $installerPath -Force
    
    Write-Host "Successfully installed the latest version of 7-zip"
}
catch {
    Write-Host "Installation Failed"
}
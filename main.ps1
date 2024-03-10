# Define variables
$scriptName = "run.ps1" 
$folderPath = "%epaperFolderPath%"
$scriptUrl = "https://github.com/fahim-ahmed05/prothomalo-epaper2pdf/raw/main/run.ps1"

# Check if the folder exists, create it if it doesn't
if (-not (Test-Path -Path $folderPath -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $folderPath | Out-Null
}

# Check if the script exists in the folder
if (Test-Path -Path (Join-Path -Path $folderPath -ChildPath $scriptName)) {
    Write-Host "Script exists in the folder. Running $scriptName"
    & (Join-Path -Path $folderPath -ChildPath $scriptName)
}
else {
    Write-Host "Script not found in the folder. Downloading from GitHub..."
    $scriptPath = Join-Path -Path $folderPath -ChildPath $scriptName
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
    Write-Host "Script downloaded. Running $scriptName"
    & $scriptPath
}

# Open explorer window
Invoke-Item "%outputFolderPath%"
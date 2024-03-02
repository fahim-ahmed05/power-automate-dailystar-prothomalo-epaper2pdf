# Store the current execution policy
$currentExecutionPolicy = Get-ExecutionPolicy -Scope Process

# Set the execution policy to Unrestricted for the current session
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted

# Check if ImageMagick is installed
if (-not (Get-Command magick.exe -ErrorAction SilentlyContinue)) {
    Write-Host -ForegroundColor Red "Error: ImageMagick is not installed."
    Write-Host -ForegroundColor Yellow "Please download and install ImageMagick from: https://imagemagick.org/script/download.php#windows"
    exit
}

# Define the image quality parameter on a scale of 0 to 100
$imageQuality = 70

# Define the website URL
$websiteUrl = "https://epaper.prothomalo.com/"

# Define file names
$htmlFileName = "website.html"
$imageLinksFileName = "links.txt"
$pdfFileName = "pa" + (Get-Date -Format "ddMMyyyy") + ".pdf"

# Define paths
$outputFolder = $env:SystemDrive + "\ePaper"
$pdfFilePath = $outputFolder + "\" + $pdfFileName
$tempFolder = $outputFolder + "\temp"
$htmlFilePath = $tempFolder + "\" + $htmlFileName
$imageLinksFilePath = $tempFolder + "\" + $imageLinksFileName
$imageFolder = $tempFolder + "\images"

# Function to delete temp folder if it exists
function Remove-TempFolder {
    param (
        [string]$tempFolderPath
    )

    if (Test-Path $tempFolderPath) {
        Write-Host -ForegroundColor Yellow "Deleting existing temp folder: $tempFolderPath"
        Remove-Item $tempFolderPath -Recurse -Force
    }
}

# Function to get website HTML source
function Get-WebsiteSource {
    param (
        [string]$url,
        [string]$outputFilePath
    )

    Write-Host -ForegroundColor Green "Downloading website source from $url..."
    # Download website source
    Invoke-WebRequest -Uri $url -OutFile $outputFilePath
    Write-Host -ForegroundColor Green "Website source downloaded and saved to $outputFilePath"
}

# Function to extract image links from HTML source
function Extract-ImageLinks {
    param (
        [string]$htmlFilePath,
        [string]$outputFilePath
    )

    Write-Host -ForegroundColor Green "Extracting image links from HTML file: $htmlFilePath..."
    # Get HTML content
    $htmlContent = Get-Content $htmlFilePath

    # Use regex to find image links
    $pattern = '"HighResolution_Without_mr"\s*:\s*"([^"]+)"'
    $imageLinks = [regex]::Matches($htmlContent, $pattern) | ForEach-Object { $_.Groups[1].Value }

    # Write links to file
    $imageLinks | Out-File $outputFilePath -Encoding utf8
    Write-Host -ForegroundColor Green "Image links extracted and saved to $outputFilePath"
}

# Function to download images
function Download-Images {
    param (
        [string]$imageLinksFilePath,
        [string]$imageFolder
    )

    # Read links from the file
    $links = Get-Content $imageLinksFilePath

    Write-Host -ForegroundColor Green "Downloading images from links file: $imageLinksFilePath..."
    # Create image folder if it doesn't exist
    if (-not (Test-Path $imageFolder)) {
        New-Item -ItemType Directory -Path $imageFolder | Out-Null
    }

    # Initialize progress
    $counter = 0
    $total = $links.Count

    foreach ($link in $links) {
        $counter++
        Write-Progress -Activity "Downloading Images" -Status "Downloading image $counter of $total" -PercentComplete (($counter / $total) * 100)
        $fileName = Join-Path -Path $imageFolder -ChildPath ([System.IO.Path]::GetFileName($link))
        Invoke-WebRequest -Uri $link -OutFile $fileName
    }
}

# Function to rename downloaded files using regex pattern
function Rename-DownloadedFiles {
    param (
        [string]$imageFolder
    )

    Write-Host -ForegroundColor Green "Renaming downloaded files in $imageFolder using regex pattern..."

    # Get all files in the folder
    $files = Get-ChildItem -Path $imageFolder

    foreach ($file in $files) {
        # Extract the file name using regex and rename the file
        $newFileName = $file.Name -replace '^.*?_', ''  # Remove everything until the first underscore
        $newFilePath = Join-Path -Path $imageFolder -ChildPath $newFileName
        Rename-Item -Path $file.FullName -NewName $newFileName
    }

    Write-Host -ForegroundColor Green "Files renamed successfully."
}

# Function to convert images to PDF
function Convert-ToPDF {
    param (
        [string]$imageFolder,
        [string]$pdfFilePath
    )

    Write-Host -ForegroundColor Green "Converting images to PDF..."
    # Convert images to PDF using ImageMagick
    magick.exe convert -quality $imageQuality $imageFolder\* $pdfFilePath
    Write-Host -ForegroundColor Green "PDF created and saved to $pdfFilePath"
}

# Main script
Write-Host -ForegroundColor Cyan "Starting script..."

# Check if the PDF file already exists in the output folder
if (Test-Path $pdfFilePath) {
    Write-Host -ForegroundColor Yellow "PDF file with the same name already exists in the output folder."
    Write-Host -ForegroundColor Yellow "Please rename or remove the existing PDF file."
    Write-Host -ForegroundColor Cyan "Script execution completed."
    exit
}

# Delete temp folder if it exists
Remove-TempFolder -tempFolderPath $tempFolder

# Create output folder if it doesn't exist
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
    Write-Host -ForegroundColor Green "Output folder created: $outputFolder"
}

# Create temp folder in root folder
if (-not (Test-Path $tempFolder)) {
    New-Item -ItemType Directory -Path $tempFolder | Out-Null
    Write-Host -ForegroundColor Green "Temporary folder created: $tempFolder"
}

# Get website source
Get-WebsiteSource -url $websiteUrl -outputFilePath ($tempFolder + "\" + $htmlFileName)

# Extract image links
Extract-ImageLinks -htmlFilePath ($tempFolder + "\" + $htmlFileName) -outputFilePath ($tempFolder + "\" + $imageLinksFileName)

# Download images
Download-Images -imageLinksFilePath ($tempFolder + "\" + $imageLinksFileName) -imageFolder ($tempFolder + "\images")

# Rename downloaded files
Rename-DownloadedFiles -imageFolder ($tempFolder + "\images")

# Convert images to PDF
Convert-ToPDF -imageFolder ($tempFolder + "\images") -pdfFilePath $pdfFilePath

# Delete temp folder
Remove-TempFolder -tempFolderPath $tempFolder

Write-Host -ForegroundColor Cyan "Script execution completed."

# Restore the original execution policy
Set-ExecutionPolicy -Scope Process -ExecutionPolicy $currentExecutionPolicy
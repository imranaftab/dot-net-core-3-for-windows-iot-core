$dotnetSDK = "dotnet-sdk-3.0.100-preview-010184-win-arm.zip"
$dotnetSDKURL = "https://download.visualstudio.microsoft.com/download/pr/ad976dfc-09d8-429b-9c49-48626898b1bf/680250d6940b02dd7a392321afec9aa6/dotnet-sdk-3.0.100-preview-010184-win-arm.zip"

$dotnetRuntime = "dotnet-sdk-3.0.100-preview-010184-win-arm.zip"
$dotnetRuntimeURL = "https://download.visualstudio.microsoft.com/download/pr/6004c6c3-015e-4900-bb45-b6ad79b05238/74fe4419b74a40895fc88eb27fa413b3/dotnet-runtime-3.0.0-preview-27324-5-win-arm.zip"
$dotnetDefaultDirectory = "C:\Program Files\dotnet"

$currentDirectory = $PSScriptRoot;

function CheckIfFileExists([string] $filename){
    $filePath = [System.IO.Path]::Combine($currentDirectory, $filename);
    return [System.IO.File]::Exists($filePath)
}
    

# Create a default diretory of dotnet core if not already exist
if( -Not (Test-Path -Path $dotnetDefaultDirectory)) {
    Write-Host "Creating a default directory for .Net Core at $($dotnetDefaultDirectory)"
    mkdir $dotnetDefaultDirectory
}

# Install dotnet core sdk
if(CheckIfFileExists($dotnetSDK)){
    Write-Host "Intalling .NET Core SDK......"
    Expand-Archive $dotnetSDK -DestinationPath $dotnetDefaultDirectory -Force
} else{
    Write-Warning "Could not find .NET Core SDK binaries zip file $($dotnetSDK) in $($currentDirectory) directory. Trying to Download .NET Core SDK from $($dotnetSDKURL)"
    $saveSDKPath = [System.IO.Path]::Combine($currentDirectory, $dotnetSDK);
    Invoke-WebRequest $dotnetSDKURL -OutFile $saveSDKPath
    Write-Host "Download completed! Installing .NET Core SDK ..."
    Expand-Archive $saveSDKPath -DestinationPath $dotnetDefaultDirectory -Force
} 

# Install dotnet core runtime
if(CheckIfFileExists($dotnetRuntime)){
    Write-Host "Intalling .Net Core Runtime......"
    Expand-Archive $dotnetRuntime -DestinationPath $dotnetDefaultDirectory -Force
} else {
    Write-Warning "Could not find .NET Core Runtime binaries zip file $($dotnetRuntime) in $($currentDirectory) directory. Trying to Download .NET Core Runtime from $($dotnetRuntimeURL)"
    $saveRuntimePath = [System.IO.Path]::Combine($currentDirectory, $dotnetRuntime);
    Invoke-WebRequest $dotnetRuntimeURL -OutFile $saveRuntimePath
    Write-Host "Download completed! Installing .NET Core Runtime ..."
    Expand-Archive $saveRuntimePath -DestinationPath $dotnetDefaultDirectory -Force
} 

# Add dotnet to system envirnment path if not already in Environment Path
If ( -NOT $Env:Path.Contains($dotnetDefaultDirectory )) {
    $Env:Path = $Env:Path+";"+$dotnetDefaultDirectory
}

Write-Host "Checking .Net Core version..."
dotnet --version
dotnet --info
Write-Host "Finished!"
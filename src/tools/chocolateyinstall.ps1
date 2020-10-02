$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# release version of kustomize: https://github.com/kubernetes-sigs/kustomize/releases
$version = '1.11.0'

$exe_name = "stern_windows_amd64.exe"

# only 64bit url
$url = "https://github.com/wercker/stern/releases/download/$version/stern_windows_amd64.exe"

# use $ checksum [exe] -t=sha256
$exe_checksum = '75708B9ACF6EF0EEFFBE1F189402ADC0405F1402E6B764F1F5152CA288E3109E'
$checksum_type = 'sha256'

# destinations
$exeLocation = join-path $toolsDir $exe_name

$getArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileFullPath  = $exeLocation
  url64bit      = $url
  checksum64    = $exe_checksum
  checksumType64= $checksum_type
}

Get-ChocolateyWebFile @getArgs

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'stern*'
  fileType      = 'exe'
  silentArgs    = ""
  validExitCodes= @(0)
  file64        = $exeLocation
  checksum64    = $exe_checksum
  checksumType64= $checksum_type
  destination   = $toolsDir
}

Install-ChocolateyInstallPackage @packageArgs

$binargs = @{
  name = 'stern'
  path = $exeLocation
}

Install-BinFile @binArgs

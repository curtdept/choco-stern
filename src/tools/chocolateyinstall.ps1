﻿$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# release version of kustomize: https://github.com/kubernetes-sigs/kustomize/releases
$version = '1.28.0'
# pattern for archive name
$base_name = "stern_$($version)_windows_amd64"
$zip_name = $base_name + ".tar.gz"
$tar_name = $base_name + ".tar"
$exe_name = "stern.exe"

# only 64bit url
$url = "https://github.com/stern/stern/releases/download/v$($version)/$($zip_name)"

# use $ checksum [exe] -t=sha256
$archive_checksum = '5A9A7DBE7B8D4F4E553766ECAE981694CEE12FA9EFB6C6A2FB1A4E82C94A97BB'
$exe_checksum = 'BF6FE6C9BF18CC24AF543E1EA19E0340A964E0FC5A257FC5C09ACAABB2D5E369'
$checksum_type = 'sha256'

# destinations
$zipLocation = join-path $toolsDir $zip_name
$exeLocation = join-path $toolsDir $exe_name

$getArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileFullPath  = $zipLocation
  url64bit      = $url
  checksum64    = $archive_checksum
  checksumType64= $checksum_type
}

Get-ChocolateyWebFile @getArgs

$unzipArgs = @{
  fileFullPath = $zipLocation
  destination = $toolsDir
}

Get-ChocolateyUnzip @unzipArgs

$unzip2Args = @{
  fileFullPath = join-path $toolsDir $tar_name
  destination = $toolsDir
}

Get-ChocolateyUnzip @unzip2Args

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'stern'
  fileType      = 'exe'
  silentArgs    = "--version"
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

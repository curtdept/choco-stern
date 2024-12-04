$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# only 64bit url
$url64 = 'https://github.com/stern/stern/releases/download/v1.31.0/stern_1.31.0_windows_amd64.tar.gz'

# use $ checksum [exe] -t=sha256
$checksum64 = '633a3b60ea269a36742d483f15843851ea0d324b30202c816be049bf183eaa1e'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= 'sha256'
  unziplocation = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
$File = Get-ChildItem -File -Path $env:ChocolateyInstall\lib\$packageName\tools\ -Filter *.tar
Get-ChocolateyUnzip -fileFullPath $File.FullName -destination $env:ChocolateyInstall\lib\$packageName\tools\

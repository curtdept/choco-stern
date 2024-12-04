import-module chocolatey-au

$ErrorActionPreference = 'Stop'

$releases = 'https://api.github.com/repos/stern/stern/releases/latest'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyinstall.ps1" = @{
      "(?i)(^[$]url64\s*=\s*)'.*'"        = "`${1}'$($Latest.URL64)'"
      "(?i)(^[$]checksum64\s*=\s*)'.*'"   = "`${1}'$($Latest.Checksum64)'"
    }
  }
}

function global:au_GetLatest {
  $json = Invoke-RestMethod -Uri $releases

  $windowsAsset = ($json.assets | Where-Object { $_.name -Match ".*windows_amd64\.tar.gz" } | Select-Object -First 1)

  return @{
    Version = $json.tag_name.Replace("v", "") # Remove prefix off of tag to make it a numeric version
    URL64   = $windowsAsset.browser_download_url
  }
}

update -ChecksumFor 64
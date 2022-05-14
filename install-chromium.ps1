$appid = "purechromium"
$accessible = Test-Connection www.google.com -Count 1 -TimeoutSeconds 2 -Quiet
$autorun = $true

$puppeteer_metainfo_url = if ($accessible) { "https://raw.githubusercontent.com/puppeteer/puppeteer/main/src/revisions.ts" } else { "https://gitcode.net/mirrors/puppeteer/puppeteer/-/raw/main/src/revisions.ts" }
$download_url_prefix = if ($accessible) { "https://commondatastorage.googleapis.com" } else { "https://cdn.npmmirror.com/binaries" }

    (Invoke-WebRequest -useb $puppeteer_metainfo_url).Content -match "(?<=chromium: ')\d+(?=',)" > $null
$version = $Matches[0]

$appdir = "$env:LOCALAPPDATA\Programs\$appid"
$instancedir = "$appdir\$version"

function getFriendlyVersion() {
    $result = Get-ChildItem "$instancedir\*.manifest" -ErrorAction Ignore
    return $result.BaseName
}

$friendlyVersion = getFriendlyVersion
if ($null -ne $friendlyVersion) {
    Write-Host "Nothing update"
}
else {
    mkdir "$env:TMP\$appid" -f > $null
    $tmpdownload = "$env:TMP\$appid\$version.zip"
    Invoke-WebRequest "$download_url_prefix/chromium-browser-snapshots/Win_x64/$version/chrome-win.zip" -o $tmpdownload

    Expand-Archive -Path $tmpdownload -DestinationPath $appdir
    Move-Item "$appdir\chrome-win" "$instancedir"

    $wsShell = New-Object -ComObject WScript.Shell
    $wsShell = $wsShell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Chromium.lnk")
    $wsShell.TargetPath = "$instancedir\chrome.exe"
    $wsShell.WorkingDirectory = $instancedir
    $wsShell.Save()

    Write-Host "==> Installed new Chromium!"
    if ($autorun -and !(Get-Process chrome -ErrorAction Ignore)) { & "$instancedir\chrome.exe" }
}

Write-Host "Chromium Instance at: $instancedir"
Write-Host "Version: $(getFriendlyVersion)"

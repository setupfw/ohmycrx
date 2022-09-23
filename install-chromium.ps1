$appid = "purechromium"
$npmmirror = $args[0] -eq 'npmmirror'
$autorun = $true

$puppeteer_metainfo_url = if ($npmmirror) { "https://gitcode.net/mirrors/puppeteer/puppeteer/-/raw/main/src/revisions.ts" } else { "https://raw.githubusercontent.com/puppeteer/puppeteer/main/src/revisions.ts" }
$download_url_prefix = if ($npmmirror) { "https://cdn.npmmirror.com/binaries" } else { "https://commondatastorage.googleapis.com" }

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
    Invoke-WebRequest -useb "$download_url_prefix/chromium-browser-snapshots/Win_x64/$version/chrome-win.zip" -o $tmpdownload

    Expand-Archive -Path $tmpdownload -DestinationPath $appdir
    Move-Item "$appdir\chrome-win" "$instancedir"

    $wsShell = New-Object -ComObject WScript.Shell
    $wsShell = $wsShell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Chromium.lnk")
    $wsShell.TargetPath = "$instancedir\chrome.exe"
    $wsShell.WorkingDirectory = $instancedir
    $wsShell.Save()

    Write-Host "==> Installed new Chromium!"
    Write-Host "tip(disable google api): cmd /c setx GOOGLE_API_KEY no"
    Write-Host
    if ($autorun -and !(Get-Process chrome -ErrorAction Ignore)) { & "$instancedir\chrome.exe" }
}

Write-Host "Chromium Instance at: $instancedir"
Write-Host "Version: $(getFriendlyVersion)"

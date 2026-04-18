# ===============================
# Oh My Posh Theme Setup Script
# Installs Oh My Posh if missing
# Writes custom theme file
# ===============================

$targetDir  = Join-Path $env:LOCALAPPDATA "oh-my-posh"
$targetFile = Join-Path $targetDir "custom.omp.toml"

# -------------------------------
# Check if Oh My Posh is installed
# -------------------------------
$ompInstalled = $null -ne (Get-Command oh-my-posh -ErrorAction SilentlyContinue)

if (-not $ompInstalled) {
    Write-Host "Oh My Posh not found. Installing..." -ForegroundColor Yellow

    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements
    }
    elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
        scoop install oh-my-posh
    }
    elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        choco install oh-my-posh -y
    }
    else {
        Write-Host "No supported package manager found." -ForegroundColor Red
        Write-Host "Install manually from: https://ohmyposh.dev/" -ForegroundColor Red
        exit 1
    }

    # Refresh PATH in current session
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")
}

# -------------------------------
# Verify install succeeded
# -------------------------------
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "Oh My Posh installation failed or requires restart." -ForegroundColor Red
    exit 1
}

Write-Host "Oh My Posh is installed." -ForegroundColor Green

# -------------------------------
# Ensure theme folder exists
# -------------------------------
New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

# -------------------------------
# Write theme file
# -------------------------------
@'
version = 2

[[blocks]]
type = "prompt"
alignment = "left"

  [[blocks.segments]]
  type = "text"
  style = "plain"
  foreground = "red"
  template = "{{ .Path }}"

  [[blocks.segments]]
  type = "text"
  style = "plain"
  foreground = "red"
  template = "]\n"

[[blocks]]
type = "prompt"
alignment = "left"

  [[blocks.segments]]
  type = "text"
  style = "plain"
  foreground = "red"
  template = "└──╼ "

  [[blocks.segments]]
  type = "text"
  style = "plain"
  foreground = "red"
  template = "❯"

  [[blocks.segments]]
  type = "text"
  style = "plain"
  foreground = "blue"
  template = "❯"

  [[blocks.segments]]
  type = "text"
  style = "plain"
  foreground = "darkGray"
  template = "❯ "
'@ | Set-Content -Path $targetFile -Encoding UTF8

Write-Host "Prompt indtalled to: $targetFile" -ForegroundColor Cyan

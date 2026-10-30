#Requires -Version 5.1
<#
    Windows counterpart to install.sh. GNU stow is not available here, so this
    links each package directly to the location Windows expects.

    Creating symlinks needs either Developer Mode enabled (Settings > System >
    For developers) or an elevated shell.

    Run prerequisites.ps1 first, or see README.md for the tool list.
#>
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

# package -> link target. Neovim reads $env:LOCALAPPDATA\nvim on Windows,
# not ~/.config/nvim.
$links = @{
    'nvim\.config\nvim' = Join-Path $env:LOCALAPPDATA 'nvim'
}

foreach ($entry in $links.GetEnumerator()) {
    $source = Join-Path $PSScriptRoot $entry.Key
    $target = $entry.Value

    if (-not (Test-Path -LiteralPath $source)) {
        Write-Warning "skipping $($entry.Key): not found in repo"
        continue
    }

    $existing = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
    if ($existing) {
        if ($existing.LinkType -eq 'SymbolicLink') {
            Write-Host "replacing existing link $target"
            $existing.Delete()
        }
        else {
            $backup = "$target.backup-$(Get-Date -Format yyyyMMdd-HHmmss)"
            Write-Host "moving existing $target to $backup"
            Move-Item -LiteralPath $target -Destination $backup
        }
    }

    $parent = Split-Path -Parent $target
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    New-Item -ItemType SymbolicLink -Path $target -Target $source | Out-Null
    Write-Host "linked $target -> $source"
}

Write-Host ''
Write-Host 'Done. Start nvim; lazy.nvim will bootstrap and install plugins.'
Write-Host 'If treesitter warns about a missing C compiler, install zig: winget install zig.zig'

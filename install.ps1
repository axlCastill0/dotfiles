#Requires -Version 5.1
<#
    Windows counterpart to install.sh. GNU stow is not available here, so this
    links each package directly to the location Windows expects.

    Creating symlinks needs either Developer Mode enabled (Settings > System >
    For developers) or an elevated shell.

    Checks prerequisites (git, node, luarocks, a C compiler) first. Pass -Deps
    to install missing ones with winget. See README.md for the full list.
#>
param(
    # Install missing prerequisites with winget instead of only reporting them.
    [switch]$Deps
)

$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

# Toolchain check. The Neovim config cannot install these itself:
#   node      mason LSP servers are npm packages
#   luarocks  lazy.nvim builds plugins shipping a rockspec (oxocarbon.nvim does)
#   zig/cl    treesitter parser compilation
$required = [ordered]@{
    'git'      = 'winget install Git.Git'
    'node'     = 'winget install OpenJS.NodeJS.LTS'
    'luarocks' = 'winget install DEVCOM.Lua; winget install LuaRocks.LuaRocks'
}

$missing = @()
foreach ($entry in $required.GetEnumerator()) {
    if (-not (Get-Command $entry.Key -ErrorAction SilentlyContinue)) {
        $missing += $entry
    }
}

if (-not (Get-Command cc, gcc, clang, cl, zig -ErrorAction SilentlyContinue)) {
    $missing += [pscustomobject]@{ Key = 'C compiler'; Value = 'winget install zig.zig' }
}

if ($missing.Count -gt 0) {
    Write-Host ''
    Write-Warning 'Missing prerequisites:'
    foreach ($m in $missing) {
        Write-Host ("  {0,-12} {1}" -f $m.Key, $m.Value)
    }
    if ($Deps) {
        foreach ($m in $missing) {
            if ($m.Key -eq 'C compiler') { $cmd = 'winget install zig.zig' } else { $cmd = $required[$m.Key] }
            Write-Host "installing $($m.Key)..."
            Invoke-Expression $cmd
        }
    }
    else {
        Write-Host ''
        Write-Host 'Re-run with -Deps to install these automatically, or run the commands above.'
        Write-Host 'Continuing with symlinks only.'
    }
    Write-Host ''
}

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

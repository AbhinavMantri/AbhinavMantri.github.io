param(
  [string]$Repo = "AbhinavMantri.github.io",
  [string]$Owner = "AbhinavMantri"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw "GitHub CLI is not installed or not available on PATH."
}

gh auth status

if (-not (Test-Path ".git")) {
  git init
}

git branch -M main
git add index.html styles.css README.md publish.ps1

if (-not (git status --short)) {
  Write-Host "No local changes to commit."
} else {
  git commit -m "Create GitHub Pages portfolio"
}

$repoFullName = "$Owner/$Repo"

if (-not (gh repo view $repoFullName --json name 2>$null)) {
  gh repo create $repoFullName --public --source . --remote origin --push
} else {
  if (-not (git remote get-url origin 2>$null)) {
    git remote add origin "https://github.com/$repoFullName.git"
  }
  git push -u origin main
}

Write-Host "Portfolio URL: https://$Owner.github.io"

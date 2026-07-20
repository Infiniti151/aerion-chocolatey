<div align="center">

[![Chocolatey Banner](https://github.com/Amitie10g/chocolatey-docker/assets/2096562/de3b0df5-2d3d-4275-a85d-dc0cc442c5e8)](https://chocolatey.org)

# Aerion Package Feed
### Native Automated Deployment Streams for AMD64 & ARM64

</div>

[![Build](https://img.shields.io/github/actions/workflow/status/Infiniti151/aerion-chocolatey/build.yml?branch=main&style=for-the-badge&logo=github-actions&logoColor=white&label=Build)](https://github.com/Infiniti151/aerion-chocolatey/actions/workflows/build.yml) [![Latest Release](https://img.shields.io/github/v/release/Infiniti151/aerion-chocolatey?style=for-the-badge&logo=github&logoColor=white&label=Release)](https://github.com/Infiniti151/aerion-chocolatey/releases) [![aerion.install](https://img.shields.io/chocolatey/v/aerion.install?style=for-the-badge&logo=chocolatey&logoColor=white&color=5C9FD8&label=aerion.install)](https://community.chocolatey.org/packages/aerion.install) [![aerion.portable](https://img.shields.io/chocolatey/v/aerion.portable?style=for-the-badge&logo=chocolatey&logoColor=white&color=5C9FD8&label=aerion.portable)](https://community.chocolatey.org/packages/aerion.portable) [![License](https://img.shields.io/github/license/Infiniti151/aerion-chocolatey?style=for-the-badge&logo=spdx&logoColor=white&color=yellow&label=License)](https://github.com/Infiniti151/aerion-chocolatey/blob/main/LICENSE)

An automated Chocolatey package repository for **[Aerion](https://aerion.3df.io/)** email client. This repository maintains an up-to-date packaging script which handles both the native installer and portable configurations.

---

## 🚀 Installation

### Prerequisites

Before installing Aerion, you must have Chocolatey installed on your system. If you don't have it yet, open an **Administrative PowerShell** session and run the following command to install it:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

You can install Aerion through the Chocolatey feed using your preferred layout:

### Option A: Standard Native Installer (.install)
This pulls down the native setup utility, handles programmatic configuration, and hooks seamlessly into Windows Apps & Features.

```powershell
choco install aerion
```

### Option B: Portable Binary (.portable)
This downloads the raw, uncompressed execution binary directly into your localized Chocolatey application sandbox. It keeps your Windows registry completely untouched and instantly configures a global CLI command-line shortcut shim so aerion can be called from any terminal session immediately.

```powerShell
choco install aerion.portable
```

## 🔄 Update
To check for upgrades and update Aerion to the latest stable release at any time, run the upgrade command corresponding to your chosen layout:

For the Standard Installer
```powerShell
choco upgrade aerion
```
For the Portable Binary
```powerShell
choco upgrade aerion.portable
```
> [!Tip]
> You can update all your installed Chocolatey packages at once by running `choco upgrade all -y`.

## ❌ Uninstallation
If you need to completely remove Aerion from your system, running the uninstall command will clean up the application binaries, strip out environmental path variables, and remove any global command-line shortcut shims automatically.

For the Standard Installer
```powerShell
choco uninstall aerion -x
```
For the Portable Binary
```powerShell
choco uninstall aerion.portable
```

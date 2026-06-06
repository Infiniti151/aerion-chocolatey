# Aerion-Chocolatey

[![Build](https://img.shields.io/github/actions/workflow/status/Infiniti151/aerion-chocolatey/build.yml?branch=main&style=for-the-badge&logo=github-actions&logoColor=white&label=Build)](https://github.com/Infiniti151/aerion-chocolatey/actions/workflows/build.yml)
[![Latest Release](https://img.shields.io/github/v/release/Infiniti151/aerion-chocolatey?style=for-the-badge&logo=github&logoColor=white&label=Release)](https://github.com/Infiniti151/aerion-chocolatey/releases)
[![aerion.install](https://img.shields.io/chocolatey/v/aerion.install?style=for-the-badge&logo=chocolatey&logoColor=white&label=aerion.install)](https://community.chocolatey.org/packages/aerion.install)
[![aerion.portable](https://img.shields.io/chocolatey/v/aerion.portable?style=for-the-badge&logo=chocolatey&logoColor=white&label=aerion.portable)](https://community.chocolatey.org/packages/aerion.portable)
[![License](https://img.shields.io/github/license/Infiniti151/aerion-chocolatey?style=for-the-badge&logo=spdx&logoColor=white&label=License)](https://github.com/Infiniti151/aerion-chocolatey/blob/main/LICENSE)

An automated Chocolatey package repository for **[Aerion](https://github.com/hkdb/aerion)** email client. This repository maintains up-to-date deployment scripts for both the native installer and portable configurations.

---

## 🚀 Installation

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
Tip: You can update all your installed Chocolatey packages at once by running `choco upgrade all -y`.

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

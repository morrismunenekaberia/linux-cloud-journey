# AWS CLI Installation

## Overview

AWS CLI (Command Line Interface) allows you to interact with AWS services from the Linux terminal.

This documentation covers the installation of AWS CLI v2 on Ubuntu.

---

## 1. Install Required Packages

Update the package list:

```bash
sudo apt update


Install curl and unzip:

sudo apt install curl unzip -y
##2. Download AWS CLI v2

Download the official AWS CLI v2 Linux installer:

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
3. Extract the Installer
unzip awscliv2.zip

This creates an aws directory containing the installer.

4. Install AWS CLI

Run:

sudo ./aws/install
5. Verify Installation

Check the installed version:

aws --version

Example:

aws-cli/2.x.x Python/3.x.x Linux/... exe/x86_64

The exact version will depend on the current AWS CLI release.

6. Clean Up Installation Files

After confirming that AWS CLI is working:

rm -rf aws awscliv2.zip
7. Check AWS CLI Location

Run:

which aws

The expected location is usually:

/usr/local/bin/aws
8. Installation Checklist
 Updated Ubuntu package list
 Installed curl
 Installed unzip
 Downloaded AWS CLI v2
 Extracted the installer
 Installed AWS CLI
 Verified AWS CLI
 Removed installation files

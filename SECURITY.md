# Security Policy

## Supported Versions

The following table lists the versions of SecurePropertyStorage that are currently supported with security updates.

We highly recommend using version 0.7.0 or later.

| Version | Supported          |
| ------- | ------------------ |
| 0.7.x   | :white_check_mark: |
| 0.6.x   | :white_check_mark: |
| 0.5.x   | :white_check_mark: |
| 0.4.x   | :white_check_mark: |
| < 0.4.0 | :x:                |

## Reporting a Vulnerability

**Submit an Issue**: Open a new issue in our [GitHub Issues](https://github.com/alexruperez/SecurePropertyStorage/issues) tracker with details of the vulnerability. Use a clear and concise title, and provide as much information as possible, including steps to reproduce, potential impact, and any suggested fixes.

> [!IMPORTANT]  
> Please note that we had a known vulnerability in versions prior to 0.4.0. This issue was related to key recovery attacks on GCM, as detailed in this [Elttam blog post](https://www.elttam.com/blog/key-recovery-attacks-on-gcm/#content). This vulnerability has been addressed in versions 0.4.0 and later. For more information, see the related [GitHub issue #13](https://github.com/alexruperez/SecurePropertyStorage/issues/13).

Thank you for helping us keep SecurePropertyStorage secure!

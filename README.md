# 🛡️ Kali Linux Advanced Security Hardening Script

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Kali%20Linux-purple.svg)
![Shell](https://img.shields.io/badge/shell-bash-orange.svg)

**Professional-grade security hardening automation for Kali Linux systems**

[Features](#-features) • [Installation](#-installation) • [Configuration](#-configuration) • [Usage](#-usage) • [Documentation](#-documentation)

</div>

---

## 📋 Overview

This comprehensive security hardening script transforms your Kali Linux installation into a fortress-level secure system. Designed for penetration testers, security professionals, and system administrators who need robust protection without compromising functionality.

### 🎯 What Makes This Script Special

- **🎨 Beautiful CLI Interface** - Color-coded output with ASCII art and progress indicators
- **🔧 Modular Configuration** - Enable/disable features through simple configuration variables
- **📊 Comprehensive Logging** - Detailed logs of all security modifications
- **🛡️ Enterprise-Grade Security** - Implements industry best practices and hardening standards
- **🔄 Reversible Changes** - Clear instructions for undoing modifications when needed

---

## ✨ Features

### 🔐 Core Security Hardening

| Feature | Description | Impact |
|---------|-------------|---------|
| **SSH Hardening** | Custom port, key-only auth, root login disabled | 🔴 Critical |
| **Firewall Configuration** | UFW with restrictive rules, ICMP disabled | 🔴 Critical |
| **Kernel Hardening** | Sysctl tuning, dangerous module blacklisting | 🟡 High |
| **File System Protection** | Immutable attributes on critical files | 🔴 Critical |

### 🚨 Intrusion Detection & Prevention

- **Fail2ban** - Permanent IP banning after 5 failed login attempts
- **Rootkit Detection** - Automated scanning with `chkrootkit` and `rkhunter`
- **System Auditing** - Comprehensive monitoring with `auditd`
- **Security Assessment** - Professional-grade scanning with `Lynis`

### 🛠️ System Optimization

- **Service Hardening** - Disables unnecessary services (Bluetooth, CUPS, Avahi, etc.)
- **SELinux Integration** - Optional mandatory access control implementation
- **File Permissions** - SUID/SGID and world-writable file detection
- **Log Management** - Centralized security event logging

---

## 🚀 Installation

### Prerequisites

```bash
# Ensure you're running as root or with sudo privileges
sudo -i

# Update your system first
apt update && apt upgrade -y
```

### Quick Install

```bash
# Clone the repository
git clone https://github.com/zar7real/kali-security-hardening.git
cd kali-security-hardening

# Make the script executable
chmod +x kali_hardening.sh

# Run the script
./kali_hardening.sh
```

---

## ⚙️ Configuration

Edit the configuration variables at the top of the script before running:

```bash
### CONFIGURATION ###
SSH_PORT=2222              # Custom SSH port (default: 2222)
LOG_FILE="/var/log/kali_security_hardening.log"  # Log file location
KERNEL_HARDENING=1         # 1 = Enable, 0 = Disable kernel hardening
SELINUX_ENABLE=1          # 1 = Enable, 0 = Disable SELinux
```

### 🎛️ Customization Options

| Option | Default | Description |
|--------|---------|-------------|
| `SSH_PORT` | 2222 | Custom SSH port to reduce automated attacks |
| `KERNEL_HARDENING` | 1 | Enable advanced kernel security features |
| `SELINUX_ENABLE` | 1 | Enable SELinux mandatory access control |
| `LOG_FILE` | `/var/log/kali_security_hardening.log` | Security audit log location |

---

## 🎯 Usage

### Basic Usage

```bash
# Standard hardening with default settings
sudo ./kali_hardening.sh
```

### Advanced Usage

```bash
# Check logs during execution
tail -f /var/log/kali_security_hardening.log

# View final security status
sudo ufw status verbose
sudo fail2ban-client status sshd
```

---

## 📊 What Gets Modified

### 🔒 Security Enhancements

<details>
<summary><strong>SSH Configuration Changes</strong></summary>

- Port changed to custom value (default: 2222)
- Root login completely disabled
- Password authentication disabled (key-only)
- X11 forwarding disabled
- Connection timeouts configured
- Rate limiting enabled

</details>

<details>
<summary><strong>Firewall Rules</strong></summary>

- Default deny incoming connections
- Allow outgoing connections
- SSH port with rate limiting
- ICMP ping requests blocked
- High-level logging enabled

</details>

<details>
<summary><strong>File System Protections</strong></summary>

**Files made immutable (cannot be modified):**
- `/boot/vmlinuz-*` (kernel files)
- `/boot/initrd.img-*` (initial ramdisk files)
- `/boot/grub/grub.cfg` (bootloader configuration)
- `/etc/passwd`, `/etc/shadow`, `/etc/group` (user databases)
- `/etc/sudoers` (sudo configuration)
- `/etc/ssh/sshd_config` (SSH configuration)

</details>

### 🛠️ System Services

**Disabled Services:**
- `avahi-daemon` (network discovery)
- `bluetooth` (Bluetooth stack)
- `cups` (printing system)
- `isc-dhcp-server` (DHCP server)

**Enabled Services:**
- `ufw` (firewall)
- `fail2ban` (intrusion prevention)
- `auditd` (system auditing)

---

## 📈 Security Impact

### Before vs After Hardening

| Security Aspect | Before | After | Improvement |
|----------------|--------|-------|-------------|
| Open Ports | 22 (SSH), many others | Custom SSH port only | 🔴→🟢 Major |
| Root Access | Enabled | Disabled | 🔴→🟢 Critical |
| Authentication | Password allowed | Key-only | 🔴→🟢 Critical |
| Intrusion Detection | None | Fail2ban + Audit | 🔴→🟢 Major |
| File Protection | Standard | Immutable critical files | 🟡→🟢 Significant |

---

## 🔧 Maintenance & Updates

### Performing System Updates

Since critical files are protected with immutable attributes, you'll need to temporarily remove protection before updates:

```bash
# Remove immutable flags before updates
sudo chattr -i /boot/vmlinuz-* /boot/initrd.img-* /boot/grub/grub.cfg
sudo chattr -R -i /boot/grub/
sudo chattr -i /etc/passwd /etc/shadow /etc/group /etc/sudoers

# Perform your updates
sudo apt update && sudo apt upgrade -y

# Re-run the hardening script to restore protections
sudo ./kali_hardening.sh
```

### Monitoring Security Status

```bash
# Check firewall status
sudo ufw status verbose

# View banned IPs
sudo fail2ban-client status sshd

# Check audit logs
sudo ausearch -k identity

# View security log
sudo tail -f /var/log/kali_security_hardening.log
```

---

## ⚠️ Important Warnings

### 🚨 Critical Considerations

- **SSH Access**: Ensure you have SSH keys configured before running, as password authentication will be disabled
- **Port Access**: Remember your custom SSH port - you'll need it for future connections
- **File Modifications**: Critical system files become immutable and cannot be modified without removing protection
- **System Updates**: Kernel and bootloader updates require temporary removal of file protections

### 🔄 Reversibility

While this script makes significant security changes, most modifications can be reversed:

1. **SSH Configuration**: Restore from automatic backup at `/etc/ssh/sshd_config.backup.*`
2. **Firewall Rules**: `sudo ufw --force reset`
3. **File Protections**: `sudo chattr -i <filename>` to remove immutable flag
4. **Services**: `sudo systemctl enable <service-name>` to re-enable disabled services

---

## 📋 System Requirements

- **OS**: Kali Linux (2020.1 or newer recommended)
- **Privileges**: Root or sudo access required
- **Dependencies**: All required packages are automatically installed
- **Storage**: Minimal additional space required
- **Network**: Internet connection for package updates

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

```bash
git clone https://github.com/zar7real/kali-security-hardening.git
cd kali-security-hardening

# Test in a virtual machine first!
# Never test security scripts on production systems
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Kali Linux Team** - For providing an excellent penetration testing platform
- **Security Community** - For establishing hardening best practices
- **Contributors** - Thank you to all who help improve this script

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/zar7real/kali-security-hardening/issues)
- **Discussions**: [GitHub Discussions](https://github.com/zar7real/kali-security-hardening/discussions)
- **Security Concerns**: Please report security issues privately

---

<div align="center">

**⭐ If this script helped secure your system, please give it a star! ⭐**

Made with ❤️ for the cybersecurity community

</div>

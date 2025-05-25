# 🔐 Secure SSH Access: Windows → Kali Linux

[![SSH](https://img.shields.io/badge/SSH-Secure%20Connection-blue?style=for-the-badge&logo=openssh)](https://www.openssh.com/)
[![Kali Linux](https://img.shields.io/badge/Kali%20Linux-Target%20System-557C94?style=for-the-badge&logo=kalilinux)](https://www.kali.org/)
[![Windows](https://img.shields.io/badge/Windows-Client%20OS-0078D4?style=for-the-badge&logo=windows)](https://www.microsoft.com/windows)

> A comprehensive guide to establish secure SSH connections from Windows to Kali Linux using public key authentication on a custom port.

## 📋 Table of Contents

- [Overview](#-overview)
- [Prerequisites](#-prerequisites)
- [Quick Setup](#-quick-setup)
- [Detailed Configuration](#-detailed-configuration)
- [Security Hardening](#-security-hardening)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)

## 🎯 Overview

This guide configures a **secure SSH tunnel** between your Windows workstation and Kali Linux system using:

- ✅ **Public Key Authentication** (no passwords)
- ✅ **Custom Port 2222** (enhanced security)
- ✅ **Modern SSH Standards** (ECDSA encryption)
- ✅ **Windows Native Tools** (PowerShell + OpenSSH)

## 🧰 Prerequisites

| Component | Requirement | Status |
|-----------|-------------|--------|
| **Target System** | Kali Linux with OpenSSH server | Required |
| **Client System** | Windows 10/11 with PowerShell | Required |
| **SSH Port** | Port 2222 configured and open | Required |
| **Network Access** | Client can reach Kali system | Required |

## ⚡ Quick Setup

### 1️⃣ Generate SSH Key Pair (Windows)

```powershell
# Open PowerShell as Administrator
ssh-keygen -t ecdsa -b 384 -f $env:USERPROFILE\.ssh\id_ecdsa
```

### 2️⃣ Deploy Public Key (Kali Linux)

```bash
# Create SSH directory structure
mkdir -p ~/.ssh && chmod 700 ~/.ssh

# Add your public key (paste the key content)
nano ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

### 3️⃣ Connect Securely

```powershell
# Connect using private key authentication
ssh -i $env:USERPROFILE\.ssh\id_ecdsa -p 2222 kali@<KALI_IP_ADDRESS>
```

## 🔧 Detailed Configuration

<details>
<summary><strong>Step 1: Key Generation on Windows</strong></summary>

1. **Launch PowerShell**
   ```powershell
   # Press Win + X, select "Windows PowerShell (Admin)"
   ```

2. **Generate Key Pair**
   ```powershell
   ssh-keygen -t ecdsa -b 384
   ```
   
3. **Configuration Prompts**
   - **File location**: Press `Enter` for default (`C:\Users\yourname\.ssh\id_ecdsa`)
   - **Passphrase**: Enter a strong passphrase (recommended) or leave empty

4. **Verify Generation**
   ```powershell
   ls $env:USERPROFILE\.ssh\
   ```
   Expected output:
   ```
   id_ecdsa      # Private key (keep secret!)
   id_ecdsa.pub  # Public key (safe to share)
   ```

</details>

<details>
<summary><strong>Step 2: Public Key Deployment</strong></summary>

1. **Extract Public Key Content**
   ```powershell
   type $env:USERPROFILE\.ssh\id_ecdsa.pub | clip
   ```
   *(Copies to clipboard)*

2. **Configure Kali Linux**
   ```bash
   # SSH directory setup
   mkdir -p ~/.ssh
   chmod 700 ~/.ssh
   
   # Add authorized key
   nano ~/.ssh/authorized_keys
   # Paste your public key, save with Ctrl+O, exit with Ctrl+X
   
   # Set permissions
   chmod 600 ~/.ssh/authorized_keys
   ```

3. **Verify Configuration**
   ```bash
   ls -la ~/.ssh/
   cat ~/.ssh/authorized_keys
   ```

</details>

<details>
<summary><strong>Step 3: Establish Connection</strong></summary>

1. **Basic Connection**
   ```powershell
   ssh -i $env:USERPROFILE\.ssh\id_ecdsa -p 2222 kali@192.168.1.100
   ```

2. **Create Connection Alias** *(Optional)*
   ```powershell
   # Edit SSH config
   notepad $env:USERPROFILE\.ssh\config
   ```
   
   Add configuration:
   ```
   Host kali-lab
       HostName 192.168.1.100
       Port 2222
       User kali
       IdentityFile ~/.ssh/id_ecdsa
       IdentitiesOnly yes
   ```
   
   Connect using alias:
   ```powershell
   ssh kali-lab
   ```

</details>

## 🛡️ Security Hardening

### Disable Password Authentication

1. **Edit SSH Configuration**
   ```bash
   sudo nano /etc/ssh/sshd_config
   ```

2. **Apply Security Settings**
   ```bash
   # Disable password authentication
   PasswordAuthentication no
   
   # Disable root login
   PermitRootLogin no
   
   # Enable public key authentication
   PubkeyAuthentication yes
   
   # Limit authentication attempts
   MaxAuthTries 3
   ```

3. **Restart SSH Service**
   ```bash
   sudo systemctl restart ssh
   sudo systemctl status ssh
   ```

### Additional Security Measures

| Setting | Configuration | Purpose |
|---------|---------------|---------|
| **Protocol Version** | `Protocol 2` | Use SSH2 only |
| **Login Grace Time** | `LoginGraceTime 30` | Limit connection time |
| **Max Sessions** | `MaxSessions 2` | Limit concurrent sessions |
| **Client Alive** | `ClientAliveInterval 300` | Auto-disconnect idle clients |

## 🔍 Troubleshooting

<details>
<summary><strong>Common Issues & Solutions</strong></summary>

### Connection Refused
```bash
# Check SSH service status
sudo systemctl status ssh

# Verify port binding
sudo netstat -tlnp | grep :2222

# Check firewall rules
sudo ufw status
```

### Permission Denied (Public Key)
```bash
# Verify key permissions
ls -la ~/.ssh/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# Check SSH logs
sudo tail -f /var/log/auth.log
```

### Key Format Issues
```powershell
# Regenerate with specific format
ssh-keygen -t ecdsa -b 384 -m PEM
```

</details>

## 📊 Connection Verification

Once connected, verify your secure session:

```bash
# Check connection details
who
w

# View SSH session info
echo $SSH_CONNECTION
echo $SSH_CLIENT

# Verify encryption
ssh -v kali-lab 2>&1 | grep -i cipher
```

## 🤝 Contributing

Found an issue or want to improve this guide?

1. **Fork** this repository
2. **Create** a feature branch (`git checkout -b feature/improvement`)
3. **Commit** your changes (`git commit -am 'Add improvement'`)
4. **Push** to the branch (`git push origin feature/improvement`)
5. **Create** a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Support

If this guide helped you, please consider:
- ⭐ **Starring** this repository
- 🐛 **Reporting** issues
- 📝 **Contributing** improvements

---

<div align="center">

**Made with ❤️ for the cybersecurity community**

[![GitHub](https://img.shields.io/badge/GitHub-Follow-181717?style=for-the-badge&logo=github)](https://github.com/zar7real)

</div>

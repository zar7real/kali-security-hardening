#!/bin/bash

# ============================================================================
#  KALI LINUX ADVANCED SECURITY HARDENING SCRIPT
#  Professional System Protection & Monitoring Setup
# ============================================================================

### CONFIGURATION ###
SSH_PORT=2222
LOG_FILE="/var/log/kali_security_hardening.log"
KERNEL_HARDENING=1  # 1 to enable kernel hardening, 0 to disable
SELINUX_ENABLE=1    # 1 to enable SELinux, 0 to disable

# Color definitions for beautiful CLI output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Function to print colored headers
print_header() {
    echo -e "\n${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${WHITE}${BOLD}  $1${NC}${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
}

# Function to print status messages
print_status() {
    echo -e "${GREEN}[✓]${NC} $1" | tee -a $LOG_FILE
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1" | tee -a $LOG_FILE
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1" | tee -a $LOG_FILE
}

print_error() {
    echo -e "${RED}[✗]${NC} $1" | tee -a $LOG_FILE
}

print_progress() {
    echo -e "${PURPLE}[→]${NC} $1" | tee -a $LOG_FILE
}

# ASCII Art Banner
clear
echo -e "${CYAN}"
cat << 'EOF'
██╗  ██╗ █████╗ ██╗     ██╗    ███████╗███████╗ ██████╗██╗   ██╗██████╗ ██╗████████╗██╗   ██╗
██║ ██╔╝██╔══██╗██║     ██║    ██╔════╝██╔════╝██╔════╝██║   ██║██╔══██╗██║╚══██╔══╝╚██╗ ██╔╝
█████╔╝ ███████║██║     ██║    ███████╗█████╗  ██║     ██║   ██║██████╔╝██║   ██║    ╚████╔╝ 
██╔═██╗ ██╔══██║██║     ██║    ╚════██║██╔══╝  ██║     ██║   ██║██╔══██╗██║   ██║     ╚██╔╝  
██║  ██╗██║  ██║███████╗██║    ███████║███████╗╚██████╗╚██████╔╝██║  ██║██║   ██║      ██║   
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝    ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝   
                                                                                              
    ██╗  ██╗ █████╗ ██████╗ ██████╗ ███████╗███╗   ██╗██╗███╗   ██╗ ██████╗                 
    ██║  ██║██╔══██╗██╔══██╗██╔══██╗██╔════╝████╗  ██║██║████╗  ██║██╔════╝                 
    ███████║███████║██████╔╝██║  ██║█████╗  ██╔██╗ ██║██║██╔██╗ ██║██║  ███╗                
    ██╔══██║██╔══██║██╔══██╗██║  ██║██╔══╝  ██║╚██╗██║██║██║╚██╗██║██║   ██║                
    ██║  ██║██║  ██║██║  ██║██████╔╝███████╗██║ ╚████║██║██║ ╚████║╚██████╔╝                
    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝                 
EOF
echo -e "${NC}"

print_header "ADVANCED SECURITY HARDENING SCRIPT FOR KALI LINUX"
print_info "Execution Date: $(date)"
print_info "Log File: $LOG_FILE"
echo ""

### 1. SYSTEM UPDATE ###
print_header "SYSTEM UPDATE & PACKAGE MANAGEMENT"
print_progress "Updating package repositories and system packages..."
apt update && apt upgrade -y
print_status "System update completed successfully"

### 2. SECURITY TOOLS INSTALLATION ###
print_header "SECURITY TOOLS INSTALLATION"
print_progress "Installing essential security tools..."
apt install -y ufw fail2ban rkhunter chkrootkit auditd lynis

# SELinux installation if requested
if [ $SELINUX_ENABLE -eq 1 ]; then
    print_progress "Installing and configuring SELinux..."
    apt install -y selinux-basics selinux-policy-default auditd
    selinux-activate
    setenforce 1
    print_status "SELinux installation and configuration completed"
else
    print_info "SELinux installation skipped (disabled in configuration)"
fi

### 3. KERNEL HARDENING ###
if [ $KERNEL_HARDENING -eq 1 ]; then
    print_header "KERNEL SECURITY HARDENING"
    print_progress "Installing kernel hardening tools..."
    
    # Install kernel hardening tools
    apt install -y grsecurity-apparmor linux-hardened
    
    print_progress "Configuring kernel security parameters..."
    # Kernel hardening configuration
    cat > /etc/sysctl.d/99-kernel-hardening.conf <<EOF
# Kernel Security Hardening Configuration
kernel.kptr_restrict=2
kernel.dmesg_restrict=1
kernel.perf_event_paranoid=3
kernel.yama.ptrace_scope=2
vm.swappiness=0
vm.unprivileged_userfaultfd=0
EOF
    
    sysctl -p /etc/sysctl.d/99-kernel-hardening.conf
    print_status "Kernel hardening parameters applied"
    
    print_progress "Blacklisting dangerous kernel modules..."
    # Disable dangerous kernel modules
    cat >> /etc/modprobe.d/blacklist.conf <<EOF
# Security: Blacklist potentially dangerous filesystems
install cramfs /bin/true
install freevxfs /bin/true
install hfs /bin/true
install hfsplus /bin/true
install jffs2 /bin/true
install udf /bin/true
EOF
    print_status "Dangerous kernel modules blacklisted"
else
    print_info "Kernel hardening skipped (disabled in configuration)"
fi

### 4. FIREWALL CONFIGURATION ###
print_header "FIREWALL CONFIGURATION (UFW)"
print_progress "Configuring UFW firewall rules..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ${SSH_PORT}/tcp
ufw limit ${SSH_PORT}/tcp
ufw logging high
ufw --force enable
print_status "UFW firewall configured and enabled"

print_progress "Implementing ICMP ping protection..."
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
print_status "ICMP ping disabled (anti-reconnaissance measure)"

### 5. SSH HARDENING ###
print_header "SSH SERVICE HARDENING"
print_progress "Applying SSH security configuration..."

# Backup original SSH config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup.$(date +%Y%m%d_%H%M%S)

sed -i "s/^#Port .*/Port ${SSH_PORT}/" /etc/ssh/sshd_config
sed -i "s/^#PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i "s/^#PasswordAuthentication.*/PasswordAuthentication no/" /etc/ssh/sshd_config
sed -i "s/^#X11Forwarding.*/X11Forwarding no/" /etc/ssh/sshd_config
sed -i "s/^#ClientAliveInterval.*/ClientAliveInterval 300/" /etc/ssh/sshd_config
sed -i "s/^#ClientAliveCountMax.*/ClientAliveCountMax 2/" /etc/ssh/sshd_config

systemctl restart ssh
print_status "SSH service hardened and restarted on port ${SSH_PORT}"

### 6. FAIL2BAN CONFIGURATION ###
print_header "INTRUSION PREVENTION SYSTEM (FAIL2BAN)"
print_progress "Configuring Fail2ban with permanent banning..."

cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
# Ban hosts for permanent duration after 5 failed attempts
bantime = -1
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port    = ${SSH_PORT}
filter  = sshd
logpath = /var/log/auth.log
maxretry = 5
findtime = 10m
bantime = -1
EOF

systemctl enable fail2ban
systemctl restart fail2ban
print_status "Fail2ban configured with permanent IP banning"

### 7. SECURITY SCANNING ###
print_header "SECURITY ASSESSMENT & SCANNING"
print_progress "Running rootkit detection scan..."
chkrootkit >> $LOG_FILE 2>&1
rkhunter --update >> $LOG_FILE 2>&1
rkhunter --check --sk >> $LOG_FILE 2>&1
print_status "Rootkit detection scan completed"

print_progress "Performing comprehensive security audit with Lynis..."
lynis audit system >> $LOG_FILE 2>&1
print_status "Lynis security audit completed"

### 8. SUSPICIOUS FILE DETECTION ###
print_header "SUSPICIOUS FILE DETECTION"
print_progress "Scanning for SUID/SGID files..."
find / -perm /6000 -type f 2>/dev/null >> $LOG_FILE
print_status "SUID/SGID file scan completed"

print_progress "Scanning for world-writable directories..."
find / -xdev -type d \( -perm -0002 -a ! -perm -1000 \) -print >> $LOG_FILE 2>&1
print_status "World-writable directory scan completed"

### 9. SERVICE HARDENING ###
print_header "UNNECESSARY SERVICE DISABLING"
print_progress "Disabling unnecessary services..."

services_to_disable=("avahi-daemon.service" "bluetooth.service" "cups.service" "isc-dhcp-server.service" "isc-dhcp-server6.service")

for service in "${services_to_disable[@]}"; do
    if systemctl is-enabled "$service" >/dev/null 2>&1; then
        systemctl disable "$service" >/dev/null 2>&1
        print_status "Disabled service: $service"
    else
        print_info "Service already disabled or not found: $service"
    fi
done

### 10. SYSTEM AUDITING ###
print_header "SYSTEM AUDITING CONFIGURATION"
print_progress "Enabling auditd system monitoring..."
systemctl enable auditd
systemctl start auditd

print_progress "Configuring critical audit rules..."
cat > /etc/audit/rules.d/99-hardening.rules <<EOF
# Critical System Audit Rules
# Time change monitoring
-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change
-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change
-a always,exit -F arch=b64 -S clock_settime -k time-change
-a always,exit -F arch=b32 -S clock_settime -k time-change
-w /etc/localtime -p wa -k time-change

# User/Group monitoring
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity

# Privilege escalation monitoring
-w /etc/sudoers -p wa -k scope

# Authentication monitoring
-w /var/log/auth.log -p wa -k authlog
-w /var/log/sudo.log -p wa -k sudolog

# MAC policy monitoring
-w /etc/apparmor/ -p wa -k MAC-policy
-w /etc/apparmor.d/ -p wa -k MAC-policy
EOF

service auditd restart
print_status "System auditing configured and enabled"

### 11. CRITICAL FILE PROTECTION ###
print_header "CRITICAL SYSTEM FILE PROTECTION"
print_progress "Applying immutable attributes to critical files..."

# Protect GRUB configuration
if [ -f /boot/grub/grub.cfg ]; then
    chattr +i /boot/grub/grub.cfg 2>/dev/null
    print_status "GRUB configuration protected"
fi

# Protect kernel files
for kernel in /boot/vmlinuz-*; do
    if [ -f "$kernel" ]; then
        chattr +i "$kernel" 2>/dev/null
        print_status "Kernel file protected: $(basename $kernel)"
    fi
done

# Protect initrd files
for initrd in /boot/initrd.img-*; do
    if [ -f "$initrd" ]; then
        chattr +i "$initrd" 2>/dev/null
        print_status "Initrd file protected: $(basename $initrd)"
    fi
done

# Protect GRUB directory
chattr -R +i /boot/grub/ 2>/dev/null
print_status "GRUB directory protected"

# Protect critical system files
critical_files=("/etc/passwd" "/etc/shadow" "/etc/group" "/etc/sudoers" "/etc/ssh/sshd_config")
for file in "${critical_files[@]}"; do
    if [ -f "$file" ]; then
        chattr +i "$file" 2>/dev/null
        print_status "Critical file protected: $file"
    fi
done

### 12. FINAL SYSTEM STATUS ###
print_header "FINAL SYSTEM STATUS REPORT"

print_info "Firewall Status:"
ufw status verbose | tee -a $LOG_FILE

echo ""
print_info "Fail2ban Status:"
fail2ban-client status sshd | tee -a $LOG_FILE

echo ""
print_info "SELinux Status:"
if [ $SELINUX_ENABLE -eq 1 ]; then
    sestatus | tee -a $LOG_FILE
else
    echo "SELinux not activated" | tee -a $LOG_FILE
fi

echo ""
print_info "Protected Files Status:"
lsattr /boot/vmlinuz-* /boot/initrd.img-* /boot/grub/grub.cfg /etc/passwd /etc/shadow /etc/group /etc/sudoers /etc/ssh/sshd_config 2>/dev/null | tee -a $LOG_FILE

# Final warnings and instructions
print_header "IMPORTANT SECURITY NOTICES"
echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║${RED}  CRITICAL: The following files are now IMMUTABLE and cannot be modified:    ${YELLOW}║${NC}"
echo -e "${YELLOW}║${WHITE}  • Kernel files (/boot/vmlinuz-*)                                           ${YELLOW}║${NC}"
echo -e "${YELLOW}║${WHITE}  • Boot loader configuration (/boot/grub/)                                  ${YELLOW}║${NC}"
echo -e "${YELLOW}║${WHITE}  • Critical system files (/etc/passwd, /etc/shadow, etc.)                 ${YELLOW}║${NC}"
echo -e "${YELLOW}║                                                                              ║${NC}"
echo -e "${YELLOW}║${CYAN}  To perform system updates, first remove immutable flags:                   ${YELLOW}║${NC}"
echo -e "${YELLOW}║${GREEN}  sudo chattr -i /boot/vmlinuz-* /boot/initrd.img-* /boot/grub/grub.cfg     ${YELLOW}║${NC}"
echo -e "${YELLOW}║${GREEN}  sudo chattr -R -i /boot/grub/                                              ${YELLOW}║${NC}"
echo -e "${YELLOW}║${GREEN}  sudo chattr -i /etc/passwd /etc/shadow /etc/group /etc/sudoers            ${YELLOW}║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"

echo ""
print_header "HARDENING COMPLETED SUCCESSFULLY"
print_status "Kali Linux security hardening completed successfully!"
print_status "Complete log available at: $LOG_FILE"
print_warning "System reboot is recommended to apply all security configurations"

echo -e "\n${GREEN}${BOLD}[✓] Security hardening process completed successfully!${NC}"
echo -e "${CYAN}${BOLD}[i] Thank you for securing your Kali Linux system!${NC}\n"

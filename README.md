[readme.md](https://github.com/user-attachments/files/22100376/readme.md)
Platinum Optimizer for Linux
https://img.shields.io/badge/Version-1.0-purple.svg
https://img.shields.io/badge/Platform-Arch_Linux-blue.svg
https://img.shields.io/badge/Shell-Bash-green.svg
https://img.shields.io/badge/License-MIT-green.svg

A comprehensive optimization script for Linux systems (especially Arch Linux) that enhances performance of CPU, GPU, memory, disk, and network through advanced kernel configurations and system tuning.

✨ Features
🔧 CPU Optimizations: Performance governor, Intel/AMD-specific tuning

🎮 GPU Optimizations: Support for NVIDIA, AMD and Intel with dedicated configurations

💾 Memory Optimizations: Advanced RAM and swap management

🚀 Kernel Optimizations: Optimized kernel parameters, I/O scheduler

🌐 Network Optimizations: TCP BBR, low-latency gaming configurations

💿 Disk Optimizations: SSD/HDD-specific configurations

🛡️ Security Tweaks: Balance between security and performance

🔄 Optimized Services: Essential performance services enabled

📋 System Requirements
Linux distribution (optimized for Arch Linux and derivatives)

Root access (sudo)

Active Internet connection

2GB+ RAM

x86_64 architecture

⚡ Installation
Download the script:

bash
curl -O https://raw.githubusercontent.com/yourusername/platinum-optimizer/main/Platinum.sh
Make it executable:

bash
chmod +x Platinum.sh
Run with root privileges:

bash
sudo ./Platinum.sh
🚀 Usage
After installation, simply run:

bash
sudo ./Platinum.sh
The script will:

Automatically detect your hardware

Show a summary of characteristics

Apply appropriate optimizations

Clean the system

Suggest a reboot

🔧 Detailed Optimization Explanation
CPU Optimizations
Performance Governor: Sets CPU frequency scaling to "performance" mode for maximum clock speeds

Intel-specific: Enables intel_pstate driver and limits C-states for responsive performance

AMD-specific: Activates amd_pstate driver for modern AMD processors

Kernel Parameters: Disables watchdog timers, optimizes scheduler settings

Core-specific: Adjusts scheduler latency based on core count (better scaling for multi-core CPUs)

GPU Optimizations
NVIDIA:

Enables persistence mode (keeps GPU initialized when not in use)

Sets PowerMizer to maximum performance

Enables Coolbits for potential overclocking

Configures Xorg settings for optimal performance

AMD:

Forces maximum performance DPM state

Installs latest Mesa and Vulkan drivers

Intel:

Sets performance power management

Installs Intel-specific graphics drivers

Automatic driver installation for all detected GPU types

Memory Optimizations
Swappiness reduction (10): Reduces tendency to swap to disk

Cache pressure adjustment (50): Optimizes filesystem cache behavior

Dirty ratio tuning: Controls when writebacks occur to disk

Min_free_kbytes optimization: Reserves appropriate emergency memory

Early OOM: Prevents system freezes by proactively killing processes before complete memory exhaustion

Disk Optimizations
SSD-specific:

Enables TRIM support (fstrim.timer)

Increases readahead value (256KB)

Disables access time recording (noatime, nodiratime)

Uses BFQ I/O scheduler for better responsiveness

HDD-specific:

Uses mq-deadline scheduler for better throughput

Filesystem tuning: Optimizes writeback timing and cache behavior

Network Optimizations
TCP BBR congestion control: Modern algorithm for better throughput and lower latency

Buffer size increases: Larger network buffers for better performance

TCP Fast Open: Reduces connection establishment time

Gaming optimizations:

Increased connection backlogs

TCP keepalive adjustments

TW bucket increases for better connection handling

MTU probing: Automatic maximum transmission unit discovery

Kernel Optimizations
Kernel Zen installation: If not present, installs the Zen kernel with performance patches

I/O scheduler configuration: BFQ for SSDs, mq-deadline for HDDs

File descriptor limit increase (1000000): Allows more simultaneous open files

Scheduler tuning: Adjustments for better interactive performance

Watchdog disable: Reduces overhead from unnecessary monitoring

Security Tweaks
Balance between security and performance:

Disables some CPU mitigations for better performance (mitigations=off)

Adjusts kernel pointer restrictions

Reduces dmesg restrictions for better debugging

Note: These changes slightly reduce security for significant performance gains

Service Optimizations
cpupower.service: Enables CPU frequency management

fstrim.timer: Regular TRIM operations for SSDs

earlyoom.service: Early out-of-memory management

irqbalance.service: Distributes interrupts across CPUs

nvidia-persistenced: Keeps NVIDIA GPUs initialized

preload: Anticipates and preloads commonly used applications

⚠️ Warnings
Backup your system before proceeding

The script modifies critical system parameters

Some optimizations disable security mitigations for performance

Reboot required to apply all changes

Primarily tested on Arch Linux - may require modifications for other distros

🔄 Rollback
The script automatically backs up modified configuration files. To restore:

Restore original configuration files from backups

Reset services to default values

Reboot the system

📊 Benchmarking
After optimization, you can test improvements with:

bash
# CPU benchmark
sysbench cpu run

# Disk benchmark
hdparm -Tt /dev/sda

# Memory benchmark
sysbench memory run

# Network benchmark
iperf3 -c your-server
🤝 Contributing
Contributions are welcome! Feel free to:

Fork the project

Create a feature branch

Commit your changes

Push to the branch

Open a Pull Request

📝 License
This project is licensed under the MIT License - see the LICENSE file for details.

🐛 Troubleshooting
If you encounter issues:

Check if your distribution is supported

Verify you have internet connectivity during installation

Examine logs in /var/log for any error messages

Restore from automatic backups created by the script

🔍 Monitoring Performance
After applying optimizations, monitor your system with:

bash
# CPU frequency
cpupower frequency-info

# GPU status
nvidia-smi # or radeontop, intel_gpu_top

# Memory usage
free -h

# Disk I/O
iotop

# Network stats
ss -tulpn
Disclaimer: Use at your own risk. The authors are not responsible for any system instability or data loss resulting from using this optimization script.

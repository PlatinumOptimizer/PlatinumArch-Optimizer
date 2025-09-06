# ⚡ PlatinumArch-Optimizer

![PlatinumArch-Optimizer Banner](https://postimg.cc/94S1bhwL)


**Advanced optimization framework for Arch Linux and Arch-based
systems.**\
This script applies a comprehensive set of **CPU, GPU, Kernel, Memory,
Storage, I/O, Network, and System optimizations** automatically.

------------------------------------------------------------------------

## 📋 Overview

PlatinumArch-Optimizer is designed for **power users and gamers** who
want the absolute best performance from their Arch-based Linux systems.\
It automatically detects **CPU, GPU, RAM, and Storage type** and applies
tuned optimizations based on hardware.

**Tested on:** Arch Linux, CachyOS\
**Compatibility:** Other distributions are not guaranteed and may break.
Use at your own risk.

------------------------------------------------------------------------

## 🛠 Installation

``` bash
# 1. Download the script
cd ~/Downloads

# 2. Make it executable
chmod +x Platinum.sh

# 3. Run as root
sudo ./Platinum.sh
```

> ⚠️ Some optimizations require a reboot to take effect.

------------------------------------------------------------------------

## ⚡ Features & Technical Details

### 🖥 CPU Optimizations

-   Forces CPU governor to **performance**\

-   Enables **irqbalance** for interrupt distribution\

-   Kernel command-line flags applied via GRUB:

    -   Intel:
        `intel_pstate=active intel_idle.max_cstate=0 processor.max_cstate=1`\
    -   AMD: `amd_pstate=active`\

-   Sysctl tuning (`/etc/sysctl.d/10-cpu-optimizations.conf`):

        vm.swappiness=10
        vm.vfs_cache_pressure=50
        vm.dirty_ratio=10
        vm.dirty_background_ratio=5
        kernel.sched_autogroup_enabled=0
        kernel.nmi_watchdog=0
        kernel.sched_migration_cost_ns=5000000

-   Forces CPU maximum frequency across all cores\

-   Disables throttling mechanisms (BD PROCHOT, turbo restrictions) when
    supported\

-   Raises thermal trip points to delay throttling

------------------------------------------------------------------------

### 🎨 GPU Optimizations

-   Automatic detection of **NVIDIA / AMD / Intel GPUs**\
-   Installs proper drivers and required Vulkan/VA libraries\
-   Vendor-specific tuning:
    -   **NVIDIA** → Persistence mode, PowerMizer Max Performance,
        Coolbits enabled for OC, power limit raised to max, GPU/memory
        overclock offsets applied\
    -   **AMD/Intel** → `power_dpm_force_performance_level=high` or
        `performance` for maximum throughput

------------------------------------------------------------------------

### 🐧 Kernel & I/O Optimizations

-   Installs **Linux Zen Kernel** for low-latency and gaming
    performance\

-   Storage schedulers:

    -   SSD → `bfq`, low latency enabled, rotational disabled\
    -   HDD → `mq-deadline`\

-   File descriptor limit raised → `fs.file-max=1000000`\

-   Advanced I/O sysctl tuning (`/etc/sysctl.d/10-advanced-io.conf`):

        vm.dirty_ratio=5
        vm.dirty_background_ratio=2
        vm.dirty_expire_centisecs=1000
        vm.dirty_writeback_centisecs=100
        vm.swappiness=1

-   Forces maximum I/O queue depth and disables randomness in disk
    queues

------------------------------------------------------------------------

### 🧠 Memory Optimizations

-   Sysctl parameters (`/etc/sysctl.d/10-memory-optimizations.conf`):

        vm.swappiness=10
        vm.dirty_ratio=10
        vm.dirty_background_ratio=5
        vm.vfs_cache_pressure=50
        inotify.max_user_watches=524288

-   For high-memory systems (≥16GB): sets `dirty_bytes` and
    `dirty_background_bytes`\

-   Enables **earlyoom.service** to prevent system freeze under low
    memory conditions\

-   Systemd configuration tuned to reduce accounting overhead\

-   Transparent Hugepages (THP) enabled and set to `always`\

-   Optimized cgroups v2 controllers for memory, CPU and I/O

------------------------------------------------------------------------

### 💾 Disk & Filesystem Optimizations

-   SSD-specific tuning:

    -   Enables **TRIM** (fstrim.timer)\
    -   Sets `read_ahead_kb=256`\
    -   Adds `noatime,nodiratime` to fstab entries\

-   Disk I/O sysctl tuning:

        vm.dirty_writeback_centisecs=1500
        vm.dirty_expire_centisecs=3000

------------------------------------------------------------------------

### 🌐 Network Optimizations

-   Creates optimized configs:
    -   `/etc/sysctl.d/10-network.conf`\
    -   `/etc/sysctl.d/10-gaming.conf`\
-   Parameters include:
    -   TCP congestion control → **BBR**\
    -   TCP fast open → enabled\
    -   Default qdisc → `fq`\
    -   Socket buffers: `rmem_max`, `wmem_max`, `tcp_rmem`, `tcp_wmem`\
    -   Gaming-specific: `netdev_max_backlog=300000`, optimized TCP
        keepalive, aggressive timeouts

------------------------------------------------------------------------

### 🔒 Security Adjustments

-   Sysctl settings tuned for minimal performance impact:

        kernel.kptr_restrict=0
        kernel.dmesg_restrict=0
        kernel.printk=3 3 3 3
        kernel.unprivileged_bpf_disabled=0
        net.core.bpf_jit_enable=1
        kernel.timer_migration=0
        kernel.sched_energy_aware=0
        kernel.numa_balancing=0

-   Disables CPU vulnerability mitigations for maximum performance

------------------------------------------------------------------------

### ⚙️ Services & Utilities

-   Enables system services:
    -   `cpupower.service`\
    -   `irqbalance.service`\
    -   `earlyoom.service`\
    -   `fstrim.timer`\
    -   `preload.service` (configured with tuned preload size &
        frequency)\
-   Installs supporting utilities: `lm_sensors`, `powertop`, `tuned`,
    `reflector`, `preload`, `usbutils`, `pciutils`

------------------------------------------------------------------------

### 🪞 Mirrorlist Optimization

-   Backups `/etc/pacman.d/mirrorlist`\
-   Uses **reflector** to fetch the 20 fastest HTTPS mirrors and updates
    pacman mirrorlist

------------------------------------------------------------------------

### 🧹 System Cleanup

-   Cleans pacman cache (keeps 1 previous version)\
-   Removes orphan packages automatically\
-   Purges `~/.cache` and `/root/.cache`\
-   Truncates `.log` files and vacuums `journalctl` to 7 days

------------------------------------------------------------------------

## 📊 Example Workflow

``` bash
# Run script
sudo ./Platinum.sh

# Script automatically:
# - Detects hardware (CPU, GPU, RAM, Storage)
# - Installs required drivers & packages
# - Applies all system-wide optimizations
# - Enables services (cpupower, irqbalance, earlyoom, preload, fstrim)
# - Optimizes mirrorlist & cleans system
```

After completion:\
- CPU and GPU locked to maximum performance states\
- Kernel tuned for throughput and low latency\
- Memory, I/O, and disk optimized for responsiveness\
- Network stack tuned for gaming and high throughput\
- System services enabled for continuous performance\
- System cleaned and ready for use

------------------------------------------------------------------------

## 👑 Credits

-   Developer: **@STEFANO83223**\
-   Designer: **@Aledect**

------------------------------------------------------------------------

## 📌 Final Notes

-   A reboot is strongly recommended after running the optimizer\
-   Monitor system temperatures with `lm_sensors`
    (`watch -n 1 sensors`)\
-   Script is intended for desktops, workstations, and gaming systems
    where maximum performance is preferred over power efficiency

# ⚡ PlatinumArch-Optimizer (Extreme Edition)

**Advanced optimization framework for Arch Linux and Arch-based
systems.**\
This script applies a comprehensive set of **CPU, GPU, Kernel, Memory,
Storage, I/O, Network, and System optimizations**, with optional
**Extreme Mode** for maximum performance.

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

-   Sets CPU governor → **performance**

-   Enables **irqbalance** to distribute interrupts

-   Kernel command-line flags:

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

-   GRUB patched with flags: `nowatchdog mitigations=off preempt=full`\

-   **Extreme Mode (Intel/AMD):**

    -   Forces maximum CPU frequency on all cores\
    -   Disables throttling mechanisms (BD PROCHOT, turbo restrictions)\
    -   Raises thermal trip points

------------------------------------------------------------------------

### 🎨 GPU Optimizations

-   Detects vendor (**NVIDIA / AMD / Intel**)\
-   Installs proper drivers and libraries\
-   Vendor tuning:
    -   **NVIDIA** → Persistence mode, PowerMizer Max Performance,
        Coolbits enabled for OC\
    -   **AMD/Intel** → `power_dpm_force_performance_level=high` or
        `performance`\
-   **Extreme Mode (NVIDIA):**
    -   Sets GPU power limit to maximum allowed\
    -   Applies automatic overclock offsets via `nvidia-settings`

------------------------------------------------------------------------

### 🐧 Kernel & I/O Optimizations

-   Installs **Linux Zen Kernel** for low-latency performance\

-   Storage schedulers:

    -   SSD → `bfq`, low latency enabled, rotational disabled\
    -   HDD → `mq-deadline`\

-   File descriptor limit raised → `fs.file-max=1000000`\

-   Advanced I/O tuning (`/etc/sysctl.d/10-advanced-io.conf`):

        vm.dirty_ratio=5
        vm.dirty_background_ratio=2
        vm.dirty_expire_centisecs=1000
        vm.dirty_writeback_centisecs=100
        vm.swappiness=1

-   **Extreme Mode:**

    -   Disables NUMA balancing, scheduler stats, energy aware
        scheduling\
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

-   Enables **earlyoom.service** to kill memory hogs before freeze\

-   Advanced:

    -   Configures systemd to reduce accounting overhead\
    -   Enables Transparent Hugepages (THP)\
    -   Optimizes cgroups v2 controllers

------------------------------------------------------------------------

### 💾 Disk & Filesystem Optimizations

-   SSD-specific:

    -   Enables **TRIM** (fstrim.timer)\
    -   Sets `read_ahead_kb=256`\
    -   Adds `noatime,nodiratime` mount options in `/etc/fstab`\

-   Disk I/O sysctl tweaks:

        vm.dirty_writeback_centisecs=1500
        vm.dirty_expire_centisecs=3000

------------------------------------------------------------------------

### 🌐 Network Optimizations

-   Creates configs:
    -   `/etc/sysctl.d/10-network.conf`\
    -   `/etc/sysctl.d/10-gaming.conf`\
-   Parameters include:
    -   TCP congestion control → **BBR**\
    -   TCP fast open → enabled\
    -   Default qdisc → `fq`\
    -   Buffer tuning: `rmem_max`, `wmem_max`, `tcp_rmem`, `tcp_wmem`\
    -   Gaming: `netdev_max_backlog=300000`, optimized TCP keepalive,
        aggressive timeouts

------------------------------------------------------------------------

### 🔒 Security Adjustments (Performance-Oriented)

-   Minimal changes to reduce performance impact:

        kernel.kptr_restrict=0
        kernel.dmesg_restrict=0
        kernel.printk=3 3 3 3

-   Advanced/Extreme: disables kernel mitigations (Meltdown, Spectre,
    etc.)

------------------------------------------------------------------------

### ⚙️ Services & Utilities

-   Enables essential services:
    -   `cpupower.service`\
    -   `irqbalance.service`\
    -   `earlyoom.service`\
    -   `fstrim.timer`\
    -   `preload.service` (configured with tuned preload size &
        frequency)\
-   Installs utilities: `lm_sensors`, `powertop`, `tuned`, `reflector`,
    `preload`, etc.

------------------------------------------------------------------------

### 🪞 Mirrorlist Optimization

-   Backs up `/etc/pacman.d/mirrorlist`\
-   Runs **reflector** to fetch the 20 fastest HTTPS mirrors and rewrite
    mirrorlist

------------------------------------------------------------------------

### 🧹 System Cleanup

-   Pacman cache cleanup (keeps 1 previous version)\
-   Removes orphaned packages\
-   Deletes user & root caches (`~/.cache`)\
-   Truncates log files and vacuums journal to 7 days

------------------------------------------------------------------------

## ⚠️ Extreme Mode Disclaimer

The **Extreme Mode** pushes CPU, GPU, and I/O beyond default safety
margins.\
✔️ Delivers maximum performance for gaming & benchmarking\
⚠️ Increases power consumption, heat, and hardware wear\
⚠️ Not recommended for laptops or thermally constrained systems

------------------------------------------------------------------------

## 📊 Example Workflow

``` bash
# Run script
sudo ./Platinum.sh

# Choose whether to enable EXTREME MODE
Apply Extreme Optimizations? (y/N): y

# Confirm
Are you sure? These may shorten hardware lifespan. (y/N): y

# System gets fully optimized
```

After completion:\
- CPU locked to performance mode\
- GPU drivers installed & tuned\
- Kernel tuned for low-latency & max throughput\
- Memory & I/O optimized\
- Services enabled (cpupower, irqbalance, earlyoom, preload, fstrim)\
- Mirrorlist refreshed\
- System cleaned

------------------------------------------------------------------------

## 👑 Credits

-   Developer: **@STEFANO83223**\
-   Designer: **@Aledect**

------------------------------------------------------------------------

## 📌 Final Notes

-   A reboot is recommended after running the optimizer\
-   For best results, monitor system temperatures with `lm_sensors` or
    `watch -n 1 sensors`\
-   Use Extreme Mode only if you understand the risks

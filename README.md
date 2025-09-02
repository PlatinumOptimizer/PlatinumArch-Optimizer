# PlatinumArch-Optimizer

**A complete optimization tool for Arch-based Linux systems.**  
Designed to improve CPU, GPU, kernel, memory, storage, network, and system performance.  

**Tested on:** CachyOS, Pure Arch Linux  
**Other distributions:** Not fully supported at this time.

---

## 1️⃣ What the script does

The script applies a full suite of optimizations, divided into these categories:

---

### CPU Optimizations

- Sets the CPU governor to **performance** to maximize speed.  
- Enables **irqbalance** to distribute CPU interrupts efficiently.  
- Configures kernel parameters for lower latency:
  - `intel_pstate` or `amd_pstate` active depending on CPU vendor  
  - Disable deep C-states (`intel_idle.max_cstate=0`)  
  - Preemption set to full (`preempt=full`)  
  - Adjusts scheduler parameters for multi-core CPUs  
- Creates a sysctl config (`10-cpu-optimizations.conf`) with:
  - `vm.swappiness=10`, `vm.vfs_cache_pressure=50`, `vm.dirty_ratio=10`, etc.  
- Updates GRUB command line with CPU optimization flags.

---

### GPU Optimizations

- Detects GPU vendor: NVIDIA, AMD, Intel.  
- Installs appropriate drivers:
  - NVIDIA: `nvidia`, `nvidia-utils`, `nvidia-settings`, `libva-vdpau-driver`, `opencl-nvidia`  
  - AMD: `mesa`, `vulkan-radeon`, `libva-mesa-driver`, `radeon-vulkan`  
  - Intel: `mesa`, `vulkan-intel`, `intel-media-driver`  
- Configures performance options:
  - NVIDIA: persistence mode, Coolbits for overclock, maximum performance mode  
  - AMD/Intel: set performance mode via sysfs  
- Enables GPU-related services (e.g., `nvidia-persistenced`)

---

### Kernel Optimizations

- Installs **Linux Zen kernel** if not present.  
- Adjusts I/O scheduler depending on storage type:
  - SSD: `bfq`, no rotational, low latency  
  - HDD: `mq-deadline`  
- Increases maximum number of open files (`fs.file-max=1000000`)  
- Applies network sysctl settings for TCP BBR, faster connections, and gaming.

---

### Memory Optimizations

- Sets swappiness to `10` for less swapping.  
- Configures cache pressure, dirty ratios, writeback intervals.  
- Adjusts `inotify.max_user_watches` for higher file watch limits.  
- For systems with ≥16GB RAM, sets `vm.dirty_bytes` and `vm.dirty_background_bytes`.  
- Enables **Early OOM** service to prevent freezes under memory pressure.

---

### Disk & Filesystem Optimizations

- Enables TRIM for SSDs (`fstrim.timer`)  
- Increases readahead for SSDs (`read_ahead_kb=256`)  
- Mounts filesystems with `noatime,nodiratime`  
- Adds additional kernel parameters for I/O (`vm.dirty_writeback_centisecs`, `vm.dirty_expire_centisecs`)

---

### Network Optimizations

- TCP/IP tuning for throughput and low latency  
- Enables TCP BBR congestion control  
- Adjusts gaming-related parameters:
  - `net.core.netdev_max_backlog`, `somaxconn`, `tcp_max_syn_backlog`  
- Reduces TCP timeouts, enables fast open, TCP MTU probing

---

### Security Tweaks

- Minimal performance-focused tweaks:
  - `kernel.kptr_restrict=0`  
  - `kernel.dmesg_restrict=0`  
  - `kernel.printk` adjusted for faster logging  
- Keeps system responsive while maintaining basic security

---

### Services & Utilities

- Enables essential services:
  - `cpupower.service`  
  - `irqbalance.service`  
  - `earlyoom.service`  
  - `fstrim.timer` for SSDs  
  - `preload.service` for faster application start  
- Installs monitoring and tuning tools: `lm_sensors`, `powertop`, `tuned`, `reflector`

---

### Mirrorlist Optimization

- Backs up existing mirrorlist  
- Uses **Reflector** to select fastest mirrors for Arch-based systems

---

### System Cleanup

- Cleans package cache (`pacman`)  
- Removes orphan packages  
- Cleans user and root caches (`~/.cache`)  
- Truncates log files and vacuums `journalctl` older than 7 days

---

### Execution Flow

1. Detects hardware (CPU, GPU, RAM, storage)  
2. Asks user confirmation to proceed  
3. Updates system and installs base packages  
4. Installs GPU drivers and applies GPU tweaks  
5. Applies CPU, memory, kernel, disk, and network optimizations  
6. Applies security tweaks  
7. Enables services and preload  
8. Optimizes mirrorlist  
9. Cleans system  
10. Offers to reboot

> ⚠️ Some optimizations require a system reboot to take full effect.

---

**Credits:**  
- Developed by Alexsuperxx09  
- Inspired by Linux performance guides and community scripts  
- Tested on CachyOS and pure Arch Linux

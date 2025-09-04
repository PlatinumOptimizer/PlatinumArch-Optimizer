# 🚀 PlatinumArch-Optimizer

**Advanced optimization framework for Arch-based Linux systems.**  
Applies a comprehensive set of **CPU, GPU, Kernel, Memory, Storage, Network, and System optimizations**.  

**🧪 Tested on:** CachyOS, Arch Linux  
**⚠️ Compatibility:** Other distributions not guaranteed  

---

## 🛠 Installation

```bash
cd ~/Downloads    # path where the script is stored
chmod +x Platinum.sh
sudo ./Platinum.sh
```

---

## 🔧 Features Overview

PlatinumArch-Optimizer applies multiple categories of optimizations.  
All changes are applied **system-wide** via sysctl, systemd services, kernel parameters, and package configuration.

---

### 🖥 CPU Optimizations
- Sets CPU governor to **performance** (`cpupower`)  
- Enables **irqbalance** for interrupt distribution  
- Adjusts kernel parameters:  
  - Intel: `intel_pstate=active`, disable deep C-states (`intel_idle.max_cstate=0`)  
  - AMD: `amd_pstate=active`  
- Applies sysctl tuning (`/etc/sysctl.d/10-cpu-optimizations.conf`):  
  - `vm.swappiness=10`  
  - `vm.vfs_cache_pressure=50`  
  - `vm.dirty_ratio=10`  
  - `kernel.sched_autogroup_enabled=0`  
- Appends optimized flags to GRUB (`nowatchdog mitigations=off preempt=full ...`)  

---

### 🎨 GPU Optimizations
- **Hardware detection** (NVIDIA / AMD / Intel)  
- Installs required GPU drivers and VA/Vulkan libraries  
- Configuration per vendor:  
  - **NVIDIA:** persistence mode, PowerMizer set to maximum, Coolbits enabled in `xorg.conf`  
  - **AMD:** `power_dpm_force_performance_level=high`  
  - **Intel:** forces max performance in `/sys/class/drm`  

---

### 🐧 Kernel Optimizations
- Installs **Linux Zen kernel** (if not already installed)  
- Configures I/O scheduler:  
  - SSD → `bfq`, disables rotational, low latency enabled  
  - HDD → `mq-deadline`  
- Increases open file descriptors: `fs.file-max=1000000`  
- Network stack tuning (`/etc/sysctl.d/10-network-optimizations.conf`):  
  - Enables **TCP BBR**  
  - Sets `tcp_fastopen=3`  
  - Default qdisc = `fq`  

---

### 🧠 Memory Optimizations
- Adjusts kernel memory management:  
  - `vm.swappiness=10`  
  - `vm.dirty_ratio=10`  
  - `vm.dirty_background_ratio=5`  
  - `vm.vfs_cache_pressure=50`  
  - `inotify.max_user_watches=524288`  
- Optimizations for high-memory systems (≥16GB): `dirty_bytes` and `dirty_background_bytes`  
- Enables **earlyoom** systemd service  

---

### 💾 Disk & Filesystem Optimizations
- SSD-specific tuning:  
  - Enables **TRIM** (`fstrim.timer`)  
  - Increases readahead (`read_ahead_kb=256`)  
  - Adds `noatime,nodiratime` to fstab entries  
- Adds sysctl I/O parameters (`dirty_writeback_centisecs`, `dirty_expire_centisecs`)  

---

### 🌐 Network Optimizations
- Creates dedicated configs:  
  - `/etc/sysctl.d/10-network.conf`  
  - `/etc/sysctl.d/10-gaming.conf`  
- Parameters:  
  - **Buffers:** `rmem_max`, `wmem_max`, `tcp_rmem`, `tcp_wmem`  
  - **Performance:** BBR congestion control, fast open, fq_codel, MTU probing  
  - **Gaming:** high backlog (`netdev_max_backlog=300000`), optimized TCP timeouts, keepalive tuning  

---

### 🔒 Security Adjustments
- Minimal modifications to prioritize performance:  
  - `kernel.kptr_restrict=0`  
  - `kernel.dmesg_restrict=0`  
  - `kernel.printk=3 3 3 3`  

---

### ⚙️ Services & Utilities
- Enables services:  
  - `cpupower.service`  
  - `irqbalance.service`  
  - `earlyoom.service`  
  - `fstrim.timer`  
  - `preload.service` (with tuned preload config)  
- Installs utilities: `lm_sensors`, `powertop`, `tuned`, `reflector`, etc.  

---

### 🪞 Mirrorlist Optimization
- Backs up `/etc/pacman.d/mirrorlist`  
- Uses **Reflector** to sort and select the fastest HTTPS mirrors  

---

### 🧹 System Cleanup
- Cleans **pacman cache** (keeps 1 previous version)  
- Removes orphan packages  
- Purges `~/.cache` and `/root/.cache`  
- Truncates log files & vacuums `journalctl` (7 days)  

---

## 👑 Credits
- Developed by **@STEFANO83223**  
- Designer **@Aledect**  

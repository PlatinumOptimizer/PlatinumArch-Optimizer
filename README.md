# 🚀 PlatinumArch-Optimizer

**The ultimate optimization tool for Arch-based Linux systems.**  
Boosts **CPU, GPU, Kernel, Memory, Storage, Network, and overall system performance**.  

**🧪 Tested on:** CachyOS, Pure Arch Linux  
**⚠️ Other distributions:** Not fully supported yet

---

# 🛠 Installation Guide 

### Move to the folder where the script is located
cd ~/Downloads  # replace with the correct path if different

---

### Make the script executable
chmod +x PlatinumArch-Optimizer.sh

---

### Run the script as root
sudo ./PlatinumArch-Optimizer.sh


---

## ✨ What the script does

PlatinumArch-Optimizer applies a **complete suite of optimizations**, organized into categories:

---

### 🖥 CPU Optimizations

- ⚡ Sets CPU governor to **performance**  
- 🔄 Enables **irqbalance** to distribute CPU interrupts efficiently  
- 🧩 Configures kernel parameters for **lower latency**:
  - `intel_pstate` / `amd_pstate` active depending on CPU  
  - Disables deep C-states (`intel_idle.max_cstate=0`)  
  - Preemption set to full (`preempt=full`)  
  - Adjusts scheduler parameters for multi-core CPUs  
- 📝 Creates `10-cpu-optimizations.conf` for sysctl tweaks (`vm.swappiness=10`, `vfs_cache_pressure=50`, `dirty_ratio=10`)  
- 🔧 Updates GRUB command line with CPU optimization flags

---

### 🎨 GPU Optimizations

- Detects GPU vendor: NVIDIA, AMD, Intel  
- Installs proper drivers depending on GPU  
- Configures performance options:
  - NVIDIA: persistence mode, Coolbits for overclock, max performance  
  - AMD/Intel: set performance mode via sysfs  
- Enables GPU services (`nvidia-persistenced`)

---

### 🐧 Kernel Optimizations

- Installs **Linux Zen kernel** if missing  
- Optimizes I/O scheduler based on storage:
  - SSD: `bfq`, low latency, no rotational  
  - HDD: `mq-deadline`  
- Increases maximum open files (`fs.file-max=1000000`)  
- Optimizes TCP/IP for faster connections & gaming (BBR enabled)

---

### 🧠 Memory Optimizations

- Swappiness = 10 → less swapping  
- Adjusts cache pressure, dirty ratios, writeback intervals  
- `inotify.max_user_watches=524288` → monitor more files  
- Extra tweaks for ≥16GB RAM (`vm.dirty_bytes`)  
- Enables **Early OOM** to prevent freezes under memory pressure

---

### 💾 Disk & Filesystem Optimizations

- TRIM enabled for SSDs (`fstrim.timer`)  
- Readahead increased (`read_ahead_kb=256`)  
- Mounts with `noatime,nodiratime` → reduces writes  
- Additional kernel I/O optimizations (`dirty_writeback_centisecs`, `dirty_expire_centisecs`)

---

### 🌐 Network Optimizations

- TCP/IP tuning for speed & low latency  
- TCP BBR congestion control enabled  
- Gaming tweaks: `netdev_max_backlog`, `somaxconn`, `tcp_max_syn_backlog`  
- Fast Open & MTU probing enabled

---

### 🔒 Security Tweaks

- Minimal performance-focused tweaks:
  - `kernel.kptr_restrict=0`  
  - `kernel.dmesg_restrict=0`  
  - `kernel.printk` optimized  
- Keeps system responsive while maintaining basic security

---

### ⚙️ Services & Utilities

- Enables key services:
  - `cpupower.service`, `irqbalance.service`, `earlyoom.service`  
  - `fstrim.timer` for SSDs  
  - `preload.service` for faster app start  
- Installs monitoring & tuning tools: `lm_sensors`, `powertop`, `tuned`, `reflector`

---

### 🪞 Mirrorlist Optimization

- Backs up current mirrorlist  
- Uses **Reflector** to select the fastest mirrors → faster updates

---

### 🧹 System Cleanup

- Cleans pacman cache & orphan packages  
- Cleans user/root caches (`~/.cache`)  
- Truncates logs & vacuums `journalctl` older than 7 days  

---


## 👑 Credits

-Development: @STEFANO83223
-Design: @Aledect
-Tested on: CachyOS & Pure Arch Linux


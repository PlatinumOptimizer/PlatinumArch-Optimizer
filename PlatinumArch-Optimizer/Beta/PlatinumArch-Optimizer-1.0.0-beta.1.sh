#!/bin/bash
# Platinum Optimizer for Linux By @STEFANO83223
# Script completo di ottimizzazioni per CPU, GPU, Kernel e sistema
# Versione ottimizzata per Arch Linux con modalità ESTREMA

# Controllo root
if [ "$EUID" -ne 0 ]; then
    echo "Esegui come root o con sudo"
    exit 1
fi

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Variabile per modalità ESTREMA
EXTREME_MODE=false

# Funzioni di logging
log_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_platinum() {
    echo -e "${PURPLE}[PLATINUM]${NC} $1"
}

log_extreme() {
    echo -e "${RED}[ESTREMA]${NC} $1"
}

# Banner PLATINUM+ OPTIMIZER
show_banner() {
    clear
    echo -e "${RED}"
    echo '██████╗ ██╗      █████╗ ████████╗██╗███╗   ██╗██╗   ██╗███╗   ███╗       █████╗ ██████╗  ██████╗██╗  ██╗'
    echo '██╔══██╗██║     ██╔══██╗╚══██╔══╝██║████╗  ██║██║   ██║████╗ ████║      ██╔══██╗██╔══██╗██╔════╝██║  ██║'
    echo '██████╔╝██║     ███████║   ██║   ██║██╔██╗ ██║██║   ██║██╔████╔██║█████╗███████║██████╔╝██║     ███████║'
    echo '██╔═══╝ ██║     ██╔══██║   ██║   ██║██║╚██╗██║██║   ██║██║╚██╔╝██║╚════╝██╔══██║██╔══██╗██║     ██╔══██║'
    echo '██║     ███████╗██║  ██║   ██║   ██║██║ ╚████║╚██████╔╝██║ ╚═╝ ██║      ██║  ██║██║  ██║╚██████╗██║  ██║'
    echo '╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝      ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝'
    echo
    echo '                    ██████╗ ██████╗ ████████╗██╗███╗   ███╗██╗███████╗███████╗██████╗'
    echo '                   ██╔═══██╗██╔══██╗╚══██╔══╝██║████╗ ████║██║╚══███╔╝██╔════╝██╔══██╗'
    echo '                   ██║   ██║██████╔╝   ██║   ██║██╔████╔██║██║  ███╔╝ █████╗  ██████╔╝'
    echo '                   ██║   ██║██╔═══╝    ██║   ██║██║╚██╔╝██║██║ ███╔╝  ██╔══╝  ██╔══██╗'
    echo '                   ╚██████╔╝██║        ██║   ██║██║ ╚═╝ ██║██║███████╗███████╗██║  ██║'
    echo '                    ╚═════╝ ╚═╝        ╚═╝   ╚═╝╚═╝     ╚═╝╚═╝╚══════╝╚══════╝╚═╝  ╚═╝'
    echo
    echo -e "${CYAN}                           The ultimate Arch Linux and Arch-based gaming optimizer          ${NC}"
    echo -e "${CYAN}              =============================  By @STEFANO83223  =============================${NC}"
    echo
}

# Aggiornamento sistema e installazione pacchetti
update_system() {
    log_platinum "Aggiornamento del sistema e installazione pacchetti necessari..."

    # Aggiornamento del sistema
    pacman -Syu --noconfirm

    # Installazione pacchetti base per ottimizzazioni
    local base_packages=(
        cpupower mesa vulkan-icd-loader libva-utils
        nvidia nvidia-utils nvidia-settings
        vulkan-radeon libva-mesa-driver mesa-vdpau
        vulkan-intel libva-intel-driver intel-media-driver
        tuned dmidecode lm_sensors powertop
        util-linux usbutils pciutils preload
        earlyoom linux-zen linux-zen-headers
        reflector irqbalance msr-tools
    )

    pacman -S --needed --noconfirm "${base_packages[@]}"
}

# Rilevamento hardware
detect_hardware() {
    log_platinum "Rilevamento hardware..."

    # CPU
    CPU_VENDOR=$(grep -m 1 "vendor_id" /proc/cpuinfo | awk '{print $3}')
    CPU_MODEL=$(grep -m 1 "model name" /proc/cpuinfo | awk -F: '{print $2}' | sed 's/^ //')
    CPU_CORES=$(nproc)

    log_info "CPU: $CPU_VENDOR $CPU_MODEL ($CPU_CORES cores)"

    # GPU
    if lspci | grep -i "nvidia" > /dev/null; then
        GPU_VENDOR="NVIDIA"
        GPU_MODEL=$(lspci | grep -i "nvidia" | head -1 | cut -d ':' -f3 | sed 's/^ //')
    elif lspci | grep -i "amd" > /dev/null; then
        GPU_VENDOR="AMD"
        GPU_MODEL=$(lspci | grep -i "amd" | head -1 | cut -d ':' -f3 | sed 's/^ //')
    elif lspci | grep -i "intel" > /dev/null; then
        GPU_VENDOR="INTEL"
        GPU_MODEL=$(lspci | grep -i "intel" | grep -i "vga" | head -1 | cut -d ':' -f3 | sed 's/^ //')
    else
        GPU_VENDOR="UNKNOWN"
        GPU_MODEL="Sconosciuta"
    fi

    log_info "GPU: $GPU_VENDOR $GPU_MODEL"

    # RAM
    TOTAL_RAM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    TOTAL_RAM_GB=$((TOTAL_RAM / 1024 / 1024))
    log_info "RAM: ${TOTAL_RAM_GB}GB"

    # Storage (SSD/HDD)
    if lsblk -d -o rota | grep -q "0"; then
        STORAGE_TYPE="SSD"
    else
        STORAGE_TYPE="HDD"
    fi
    log_info "Storage: $STORAGE_TYPE"

    # Rilevamento disco root
    ROOT_DISK=$(findmnt -n -o SOURCE / | sed 's/[0-9]*$//' | xargs basename 2>/dev/null || echo "sda")
    log_info "Disco root: $ROOT_DISK"
}

# Installazione driver GPU specifici
install_gpu_drivers() {
    log_platinum "Installazione driver GPU per $GPU_VENDOR..."

    case "$GPU_VENDOR" in
        "NVIDIA")
            local nvidia_packages=(
                nvidia nvidia-utils nvidia-settings
                libva-vdpau-driver opencl-nvidia
            )
            pacman -S --needed --noconfirm "${nvidia_packages[@]}"

            # Configurazione NVIDIA
            mkdir -p /etc/modprobe.d
            echo "options nvidia_drm modeset=1" > /etc/modprobe.d/nvidia.conf
            ;;

        "AMD")
            local amd_packages=(
                mesa vulkan-radeon libva-mesa-driver
                mesa-vdpau radeon-vulkan vulkan-icd-loader
            )
            pacman -S --needed --noconfirm "${amd_packages[@]}"
            ;;

        "INTEL")
            local intel_packages=(
                mesa vulkan-intel libva-intel-driver
                intel-media-driver intel-gpu-tools
            )
            pacman -S --needed --noconfirm "${intel_packages[@]}"
            ;;
    esac
}

# Ottimizzazioni CPU
apply_cpu_optimizations() {
    log_platinum "Applicazione ottimizzazioni CPU..."

    # Governor prestazioni
    if command -v cpupower > /dev/null; then
        cpupower frequency-set -g performance
        systemctl enable cpupower.service
    fi

    # IRQ Balance
    systemctl enable irqbalance.service

    # Kernel parameters per CPU
    local cpu_optimizations=""
    case "$CPU_VENDOR" in
        "GenuineIntel")
            cpu_optimizations="intel_pstate=active intel_idle.max_cstate=0 processor.max_cstate=1"
            ;;
        "AuthenticAMD")
            cpu_optimizations="amd_pstate=active"
            ;;
    esac

    # Parametri generici CPU
    cat > /etc/sysctl.d/10-cpu-optimizations.conf << EOF
kernel.nmi_watchdog=0
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_ratio=10
vm.dirty_background_ratio=5
vm.dirty_writeback_centisecs=1500
kernel.sched_migration_cost_ns=5000000
kernel.sched_autogroup_enabled=0
EOF

    # Ottimizzazioni specifiche per numero di core
    if [ "$CPU_CORES" -ge 8 ]; then
        echo "kernel.sched_latency_ns=6000000" >> /etc/sysctl.d/10-cpu-optimizations.conf
        echo "kernel.sched_min_granularity_ns=400000" >> /etc/sysctl.d/10-cpu-optimizations.conf
    fi

    # Aggiungi parametri al kernel
    if [ -f "/etc/default/grub" ]; then
        local current_cmdline=$(grep "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub | cut -d'"' -f2)
        local new_cmdline="$current_cmdline nowatchdog mitigations=off preempt=full $cpu_optimizations"
        sed -i "s|GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"$new_cmdline\"|" /etc/default/grub

        # Aggiorna GRUB
        if command -v grub-mkconfig > /dev/null; then
            grub-mkconfig -o /boot/grub/grub.cfg
        fi
    fi
}

# Ottimizzazioni GPU
apply_gpu_optimizations() {
    log_platinum "Applicazione ottimizzazioni GPU..."

    case "$GPU_VENDOR" in
        "NVIDIA")
            # Abilita persistence mode
            nvidia-smi -pm 1

            # Imposta massime prestazioni
            nvidia-settings -a '[gpu:0]/GpuPowerMizerMode=1' 2>/dev/null

            # Coolbits per overclocking
            if [ -f "/etc/X11/xorg.conf" ]; then
                sed -i '/Section "Device"/,/EndSection/ { /Option "Coolbits"/d }' /etc/X11/xorg.conf
                echo '    Option "Coolbits" "28"' >> /etc/X11/xorg.conf
            else
                # Crea file di configurazione se non esiste
                cat > /etc/X11/xorg.conf << EOF
Section "Device"
    Identifier "Device0"
    Driver "nvidia"
    Option "Coolbits" "28"
EndSection
EOF
            fi

            # Abilita servizi NVIDIA
            systemctl enable nvidia-persistenced.service
            ;;

        "AMD"|"INTEL")
            # Trova il percorso corretto per la GPU
            for card in /sys/class/drm/card*/; do
                if [ -f "${card}device/power_dpm_force_performance_level" ]; then
                    echo "performance" > "${card}device/power_dpm_force_performance_level" 2>/dev/null || \
                    echo "high" > "${card}device/power_dpm_force_performance_level" 2>/dev/null || \
                    echo "max" > "${card}device/power_dpm_force_performance_level" 2>/dev/null
                    break
                fi
            done
            ;;
    esac
}

# Ottimizzazioni Kernel
apply_kernel_optimizations() {
    log_platinum "Applicazione ottimizzazioni Kernel..."

    # Installa kernel Zen se non presente
    if ! pacman -Q linux-zen 2>/dev/null; then
        pacman -S --needed --noconfirm linux-zen linux-zen-headers
    fi

    # Ottimizzazioni I/O scheduler
    if [ -d "/sys/block/${ROOT_DISK}/queue" ]; then
        if [ "$STORAGE_TYPE" = "SSD" ]; then
            echo "bfq" > "/sys/block/${ROOT_DISK}/queue/scheduler" 2>/dev/null || true
            echo "0" > "/sys/block/${ROOT_DISK}/queue/rotational" 2>/dev/null || true
            if [ -f "/sys/block/${ROOT_DISK}/queue/iosched/low_latency" ]; then
                echo "1" > "/sys/block/${ROOT_DISK}/queue/iosched/low_latency" 2>/dev/null || true
            fi
        else
            echo "mq-deadline" > "/sys/block/${ROOT_DISK}/queue/scheduler" 2>/dev/null || true
        fi
    fi

    # Aumenta limite dei file aperti
    echo "fs.file-max = 1000000" > /etc/sysctl.d/10-file-max.conf
}

# Ottimizzazioni memoria
apply_memory_optimizations() {
    log_platinum "Applicazione ottimizzazioni memoria..."

    # Calcola valori ottimali in base alla RAM
    local min_filelist=$((TOTAL_RAM / 2))
    local max_filelist=$((TOTAL_RAM * 2))

    cat > /etc/sysctl.d/10-memory-optimizations.conf << EOF
vm.min_free_kbytes = $((TOTAL_RAM / 200))  # 0.5% della RAM
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5
vm.dirty_writeback_centisecs = 1500
vm.vfs_cache_pressure = 50
vm.swappiness = 10
inotify.max_user_watches = 524288
EOF

    # Ottimizzazioni specifiche per grandi quantità de RAM
    if [ "$TOTAL_RAM_GB" -ge 16 ]; then
        echo "vm.dirty_bytes = 268435456" >> /etc/sysctl.d/10-memory-optimizations.conf
        echo "vm.dirty_background_bytes = 134217728" >> /etc/sysctl.d/10-memory-optimizations.conf
    fi

    # Early OOM (Out Of Memory) per prevenire freeze del sistema
    if systemctl list-unit-files | grep -q earlyoom.service; then
        systemctl enable earlyoom.service
    else
        log_warning "earlyoom.service non trovato, installazione in corso..."
        pacman -S --noconfirm earlyoom
        systemctl enable earlyoom.service
    fi
}

# Ottimizzazioni disco e filesystem
apply_disk_optimizations() {
    log_platinum "Applicazione ottimizzazioni disco e filesystem..."

    # Ottimizzazioni per SSD
    if [ "$STORAGE_TYPE" = "SSD" ]; then
        # Abilita TRIM
        systemctl enable fstrim.timer

        # Aumenta readahead per SSD
        if [ -d "/sys/block/${ROOT_DISK}/queue" ]; then
            echo 256 > "/sys/block/${ROOT_DISK}/queue/read_ahead_kb" 2>/dev/null || true
        fi

        # Disabilita access time
        sed -i '/\/dev\/sd/ s/defaults/defaults,noatime,nodiratime/' /etc/fstab 2>/dev/null || true
    fi

    # Ottimizzazioni I/O
    cat > /etc/sysctl.d/10-disk-optimizations.conf << EOF
vm.dirty_writeback_centisecs = 1500
vm.dirty_expire_centisecs = 3000
EOF
}

# Ottimizzazioni sicurezza (minime per performance)
apply_security_tweaks() {
    log_platinum "Applicazione tweaks sicurezza..."

    # Disabilita alcuni mitigazioni per le performance
    cat > /etc/sysctl.d/10-security-tweaks.conf << EOF
kernel.kptr_restrict = 0
kernel.dmesg_restrict = 0
kernel.printk = 3 3 3 3
EOF
}

# Ottimizzazioni ESTREME per CPU
apply_extreme_cpu_optimizations() {
    log_extreme "Applicazione ottimizzazioni CPU ESTREME..."

    case "$CPU_VENDOR" in
        "GenuineIntel")
            log_info "Applicazione ottimizzazioni ESTREME per Intel CPU..."

            # Set Intel pstate to maximum performance
            if [ -f "/sys/devices/system/cpu/intel_pstate/no_turbo" ]; then
                echo 0 | tee /sys/devices/system/cpu/intel_pstate/no_turbo > /dev/null 2>&1
            fi

            if [ -f "/sys/devices/system/cpu/intel_pstate/max_perf_pct" ]; then
                echo 100 | tee /sys/devices/system/cpu/intel_pstate/max_perf_pct > /dev/null 2>&1
            fi

            if [ -f "/sys/devices/system/cpu/intel_pstate/min_perf_pct" ]; then
                echo 100 | tee /sys/devices/system/cpu/intel_pstate/min_perf_pct > /dev/null 2>&1
            fi

            # Set governor to performance for each CPU
            for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
                if [ -f "$cpu" ]; then
                    echo performance | tee $cpu > /dev/null 2>&1
                fi
            done

            # Disable BD PROCHOT if possible (requires msr-tools)
            if command -v wrmsr > /dev/null; then
                wrmsr -a 0x1FC 0 > /dev/null 2>&1
            fi

            # Increase thermal limits (if available)
            for zone in /sys/class/thermal/thermal_zone*/trip_point_*_temp; do
                if [ -f "$zone" ]; then
                    echo 95000 | tee $zone > /dev/null 2>&1
                fi
            done
            ;;

        "AuthenticAMD")
            log_info "Applicazione ottimizzazioni ESTREME per AMD CPU..."

            # Set governor to performance for each CPU
            for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
                if [ -f "$cpu" ]; then
                    echo performance | tee $cpu > /dev/null 2>&1
                fi
            done

            # Set min and max frequency to the maximum (if available)
            for cpu in /sys/devices/system/cpu/cpu*/cpufreq; do
                if [ -f "$cpu/scaling_min_freq" ]; then
                    cat "$cpu/cpuinfo_max_freq" | tee "$cpu/scaling_min_freq" > /dev/null 2>&1
                fi
                if [ -f "$cpu/scaling_max_freq" ]; then
                    cat "$cpu/cpuinfo_max_freq" | tee "$cpu/scaling_max_freq" > /dev/null 2>&1
                fi
            done
            ;;
    esac
}

# Ottimizzazioni ESTREME per GPU
apply_extreme_gpu_optimizations() {
    log_extreme "Applicazione ottimizzazioni GPU ESTREME..."

    case "$GPU_VENDOR" in
        "NVIDIA")
            log_info "Applicazione ottimizzazioni ESTREME per NVIDIA GPU..."

            # Set power limit to maximum (requires nvidia-smi)
            MAX_POWER=$(nvidia-smi --query-gpu=power.max_limit --format=csv,noheader,nounits | head -1)
            if [ ! -z "$MAX_POWER" ]; then
                nvidia-smi --power-limit=$MAX_POWER > /dev/null 2>&1
            fi

            # Enable persistent mode
            nvidia-smi --persistence-mode=1 > /dev/null 2>&1

            # Set performance mode to maximum
            nvidia-settings -a '[gpu:0]/GpuPowerMizerMode=1' > /dev/null 2>&1

            # Set clock offsets to maximum (if supported)
            nvidia-settings -a '[gpu:0]/GPUGraphicsClockOffset[3]=100' > /dev/null 2>&1
            nvidia-settings -a '[gpu:0]/GPUMemoryTransferRateOffset[3]=100' > /dev/null 2>&1
            ;;

        "AMD"|"INTEL")
            log_info "Applicazione ottimizzazioni ESTREME per $GPU_VENDOR GPU..."

            # Trova il percorso corretto per la GPU
            for card in /sys/class/drm/card*/; do
                if [ -f "${card}device/power_dpm_force_performance_level" ]; then
                    echo "high" > "${card}device/power_dpm_force_performance_level" 2>/dev/null || \
                    echo "performance" > "${card}device/power_dpm_force_performance_level" 2>/dev/null || \
                    echo "max" > "${card}device/power_dpm_force_performance_level" 2>/dev/null
                    break
                fi
            done

            # Set power limit to maximum (if available)
            for hwmon in /sys/class/drm/card*/device/hwmon/hwmon*/; do
                if [ -f "${hwmon}power1_cap_max" ]; then
                    MAX_POWER=$(cat "${hwmon}power1_cap_max" 2>/dev/null)
                    if [ ! -z "$MAX_POWER" ]; then
                        echo $MAX_POWER > "${hwmon}power1_cap" 2>/dev/null
                    fi
                    break
                fi
            done
            ;;
    esac
}

# Ottimizzazioni avanzate per filesystem e I/O
apply_advanced_io_optimizations() {
    log_platinum "Applicazione ottimizzazioni I/O avanzate..."

    # Ottimizzazioni per filesystem EXT4/BTRFS
    if mount | grep -q "ext4"; then
        if [ -d "/sys/block/${ROOT_DISK}/queue" ]; then
            echo "deadline" > "/sys/block/${ROOT_DISK}/queue/scheduler" 2>/dev/null || true
            echo 0 > "/sys/block/${ROOT_DISK}/queue/rotational" 2>/dev/null || true
            echo 256 > "/sys/block/${ROOT_DISK}/queue/nr_requests" 2>/dev/null || true
        fi
    fi

    # Aumenta i limiti di I/O
    echo 1048576 > /proc/sys/fs/aio-max-nr 2>/dev/null || true

    # Ottimizzazioni per database e carichi pesanti
    cat > /etc/sysctl.d/10-advanced-io.conf << EOF
vm.dirty_ratio = 5
vm.dirty_background_ratio = 2
vm.dirty_expire_centisecs = 1000
vm.dirty_writeback_centisecs = 100
vm.swappiness = 1
EOF
}

# Ottimizzazioni avanzate di memoria
apply_advanced_memory_optimizations() {
    log_platinum "Applicazione ottimizzazioni memoria avanzate..."

    # Ottimizzazioni per systemd
    mkdir -p /etc/systemd/system.conf.d/
    cat > /etc/systemd/system.conf.d/10-memory-optimize.conf << EOF
[Manager]
DefaultCPUAccounting=no
DefaultIOAccounting=no
DefaultIPAccounting=no
DefaultBlockIOAccounting=no
DefaultMemoryAccounting=no
DefaultTasksAccounting=no
EOF

    # Ottimizzazioni per transparent hugepages
    if [ -f "/sys/kernel/mm/transparent_hugepage/enabled" ]; then
        echo "always" > /sys/kernel/mm/transparent_hugepage/enabled 2>/dev/null || true
    fi
    if [ -f "/sys/kernel/mm/transparent_hugepage/defrag" ]; then
        echo "madvise" > /sys/kernel/mm/transparent_hugepage/defrag 2>/dev/null || true
    fi

    # Ottimizzazioni per cgroups v2
    if [ -d /sys/fs/cgroup ]; then
        if [ -f /sys/fs/cgroup/cgroup.controllers ]; then
            echo "memory" > /sys/fs/cgroup/cgroup.subtree_control 2>/dev/null || true
            echo "cpu" > /sys/fs/cgroup/cgroup.subtree_control 2>/dev/null || true
            echo "io" > /sys/fs/cgroup/cgroup.subtree_control 2>/dev/null || true
        fi
    fi
}

# Ottimizzazioni avanzate per sicurezza performante
apply_advanced_security_optimizations() {
    log_platinum "Applicazione ottimizzazioni sicurezza avanzate..."

    # Rimuove mitigazioni per massime prestazioni
    cat > /etc/sysctl.d/10-advanced-security.conf << EOF
kernel.kptr_restrict = 0
kernel.dmesg_restrict = 0
kernel.printk = 3 3 3 3
kernel.unprivileged_bpf_disabled = 0
net.core.bpf_jit_enable = 1
kernel.timer_migration = 0
kernel.sched_energy_aware = 0
kernel.numa_balancing = 0
kernel.ipc = 0
EOF
}

# Ottimizzazioni ESTREME avanzate
apply_extreme_advanced_optimizations() {
    log_extreme "Applicazione ottimizzazioni ESTREME avanzate..."

    # Disabilita completamente le mitigazioni
    echo 0 > /proc/sys/kernel/numa_balancing 2>/dev/null || true
    echo 0 > /proc/sys/kernel/sched_schedstats 2>/dev/null || true
    echo 0 > /proc/sys/kernel/sched_energy_aware 2>/dev/null || true

    # Ottimizzazioni CPU estreme
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/; do
        [ -f "${cpu}scaling_min_freq" ] && cat "${cpu}cpuinfo_max_freq" | tee "${cpu}scaling_min_freq" >/dev/null 2>&1 || true
        [ -f "${cpu}scaling_max_freq" ] && cat "${cpu}cpuinfo_max_freq" | tee "${cpu}scaling_max_freq" >/dev/null 2>&1 || true
        [ -f "${cpu}scaling_governor" ] && echo "performance" | tee "${cpu}scaling_governor" >/dev/null 2>&1 || true
    done

    # Ottimizzazioni I/O estreme
    if [ -d "/sys/block/${ROOT_DISK}/queue" ]; then
        echo 1024 > "/sys/block/${ROOT_DISK}/queue/nr_requests" 2>/dev/null || true
        echo 0 > "/sys/block/${ROOT_DISK}/queue/rotational" 2>/dev/null || true
        echo 0 > "/sys/block/${ROOT_DISK}/queue/add_random" 2>/dev/null || true
        echo 0 > "/sys/block/${ROOT_DISK}/queue/iostats" 2>/dev/null || true
        echo 256 > "/sys/block/${ROOT_DISK}/queue/read_ahead_kb" 2>/dev/null || true
    fi
}

# Configurazione servizi
enable_services() {
    log_platinum "Abilitazione servizi..."

    # Servizi base
    systemctl enable cpupower.service

    # Per SSD
    if [ "$STORAGE_TYPE" = "SSD" ]; then
        systemctl enable fstrim.timer
    fi

    # earlyoom
    if systemctl list-unit-files | grep -q earlyoom.service; then
        systemctl enable earlyoom.service
    else
        log_warning "earlyoom.service non trovato, installazione in corso..."
        pacman -S --noconfirm earlyoom
        systemctl enable earlyoom.service
    fi

    # irqbalance
    if systemctl list-unit-files | grep -q irqbalance.service; then
        systemctl enable irqbalance.service
    else
        log_warning "irqbalance.service non trovato, installazione in corso..."
        pacman -S --noconfirm irqbalance
        systemctl enable irqbalance.service
    fi

    # Servizi specifici GPU
    if [ "$GPU_VENDOR" = "NVIDIA" ]; then
        systemctl enable nvidia-persistenced.service
    fi
}

# Configurazione preload
setup_preload() {
    log_platinum "Configurazione preload..."

    if command -v preload > /dev/null; then
        systemctl enable preload.service

        # Configurazione preload
        sed -i 's/^#PRELOAD_SIZE.*/PRELOAD_SIZE=1024m/' /etc/preload.conf
        sed -i 's/^#PRELOAD_FREQ.*/PRELOAD_FREQ=10/' /etc/preload.conf
    fi
}

# Ottimizzazioni mirrorlist
optimize_mirrorlist() {
    log_platinum "Ottimizzazione mirrorlist per Arch Linux..."

    # Backup mirrorlist originale
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

    # Utilizza reflector per ottenere mirror più veloci
    if command -v reflector > /dev/null; then
        reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --connection-timeout 10
    fi
}

# Pulizia sistema
clean_system() {
    log_platinum "Pulizia sistema..."

    # Pulizia cache pacman
    paccache -rk1

    # Pulizia cache utente
    find /home -type d -name '.cache' -exec rm -rf {} + 2>/dev/null || true
    find /root -type d -name '.cache' -exec rm -rf {} + 2>/dev/null || true

    # Pulizia log
    find /var/log -type f -name '*.log' -exec truncate -s 0 {} \;
    journalctl --vacuum-time=7d

    # Rimuove pacchetti orfani
    pacman -Rns $(pacman -Qtdq) --noconfirm 2>/dev/null || true
}

# Funzione principale
main() {
    show_banner

    # Rilevamento hardware
    detect_hardware

    # Richiesta modalità ESTREMA
    read -p "Applicare ottimizzazioni ESTREME? (s/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        EXTREME_MODE=true
        log_warning "ATTENZIONE: Le ottimizzazioni ESTREME possono aumentare il consumo energetico e la temperatura, e potrebbero ridurre la vita utile dell'hardware."
        read -p "Sei sicuro di voler continuare? (s/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Ss]$ ]]; then
            EXTREME_MODE=false
            log_info "Modalità ESTREMA annullata."
        else
            log_info "Modalità ESTREMA abilitata."
        fi
    fi

    # Conferma
    read -p "Continuare con l'ottimizzazione? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "Operazione annullata."
        exit 0
    fi

    # Esecuzione ottimizzazioni
    update_system
    install_gpu_drivers
    apply_cpu_optimizations
    apply_gpu_optimizations
    apply_kernel_optimizations
    apply_memory_optimizations
    apply_disk_optimizations
    apply_security_tweaks

    # Applica ottimizzazioni avanzate
    apply_advanced_io_optimizations
    apply_advanced_memory_optimizations
    apply_advanced_security_optimizations

    # Applica ottimizzazioni ESTREME se richiesto
    if [ "$EXTREME_MODE" = true ]; then
        apply_extreme_cpu_optimizations
        apply_extreme_gpu_optimizations
        apply_extreme_advanced_optimizations
    fi

    enable_services
    setup_preload
    optimize_mirrorlist
    clean_system

    log_success "Ottimizzazioni completate!"
    echo
    log_info "Riepilogo ottimizzazioni applicate:"
    log_info "- CPU: Governor performance, ottimizzazioni specifiche $CPU_VENDOR"
    log_info "- GPU: Driver e ottimizzazioni per $GPU_VENDOR"
    log_info "- Kernel: Parametri ottimizzati, I/O scheduler"
    log_info "- Memoria: Swappiness ridotto, cache pressure ottimizzato"
    log_info "- Disco: Ottimizzazioni per $STORAGE_TYPE"
    log_info "- Servizi: Abilitati cpupower, fstrim, earlyoom, irqbalance"
    log_info "- Ottimizzazioni Avanzate: I/O, Memoria e Sicurezza"

    if [ "$EXTREME_MODE" = true ]; then
        log_extreme "- Modalità ESTREMA: Ottimizzazioni aggressive applicate"
        log_warning "Monitorare attentamente le temperature del sistema!"
    fi

    echo
    log_warning "Alcune ottimizzazioni richiedono a riavvio per essere effettive."
    log_warning "Si consiglia di riavviare il sistema."
    echo
    read -p "Riavviare ora? (s/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        reboot
    fi
}

main

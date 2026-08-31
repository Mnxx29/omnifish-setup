#!/bin/bash
# ============================================================
#  Omnifish - Script de configuración PC (Ubuntu 24.04 LTS)
#  Uso: copiar esta carpeta al pendrive junto con los .deb
#       Ejecutar con: sudo bash instalacion.sh
# ============================================================

set -e  # Detener si hay error grave no controlado
export DEBIAN_FRONTEND=noninteractive

VERDE="\e[32m"
AMARILLO="\e[33m"
ROJO="\e[31m"
CYAN="\e[36m"
NEGRITA="\e[1m"
RESET="\e[0m"

OK="${VERDE}${NEGRITA}[OK]${RESET}"
WARN="${AMARILLO}${NEGRITA}[!]${RESET}"
INFO="${CYAN}${NEGRITA}[*]${RESET}"
ERR="${ROJO}${NEGRITA}[ERROR]${RESET}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG="$SCRIPT_DIR/instalacion_$(date +%Y%m%d_%H%M%S).log"

log() { echo -e "$1" | tee -a "$LOG"; }
separador() { log "\n${CYAN}══════════════════════════════════════════${RESET}"; }

separador
log "${NEGRITA}  Omnifish — Script de configuración PC (Ubuntu 24.04 LTS)${RESET}"
log "  Log guardado en: $LOG"
separador

# ── VERIFICACIÓN DE PRIVILEGIOS ──────────────────────────────
if [ "$EUID" -ne 0 ]; then
    echo -e "\n${ERR} Este script debe ejecutarse con privilegios de superusuario (root/sudo)."
    echo -e "     Por favor ejecuta: ${CYAN}sudo bash instalacion.sh${RESET}\n"
    exit 1
fi

# ── AUTO-ACTUALIZACIÓN DESDE GITHUB ────────────────────────────
if [ -d "$SCRIPT_DIR/.git" ] && command -v git &>/dev/null; then
    log "\n${INFO} Verificando actualizaciones del repositorio en GitHub..."
    git -C "$SCRIPT_DIR" pull origin main 2>&1 | tee -a "$LOG" || log "${WARN} No se pudo sincronizar con GitHub (se usará la versión local)."
fi

# ── FASE 0: Habilitar Repositorios Ubuntu 24.04 & Dependencias Base ───────
separador
log "\n${INFO} FASE 0: Habilitando repositorios y dependencias del sistema..."

log "  → Habilitando repositorios universe y multiverse"
add-apt-repository universe -y 2>&1 | tee -a "$LOG" >/dev/null || true
add-apt-repository multiverse -y 2>&1 | tee -a "$LOG" >/dev/null || true

log "  → Pre-instalando herramientas, librerías clave y VLC Media Player"
apt update -y 2>&1 | tee -a "$LOG" >/dev/null || true
apt install -y software-properties-common git curl wget gpg ca-certificates lsb-release net-tools libcanberra-gtk-module libcanberra-gtk3-module libgconf-2-4 vlc 2>&1 | tee -a "$LOG" | grep -E "upgraded|installed|removed|^Err" || true

log "$OK FASE 0 completada."

# ── FASE 1: Re-contra actualización inicial base ───────────────────────────
separador
log "\n${INFO} FASE 1: Re-contra actualizando sistema base..."

log "  → apt update"
apt update -y 2>&1 | tee -a "$LOG" | grep -E "Get:|Ign:|Hit:|Err:" || true

log "  → apt full-upgrade (actualizando todo el SO a la última versión disponible)"
apt full-upgrade -y 2>&1 | tee -a "$LOG" | grep -E "upgraded|installed|removed|^Err" || true

log "  → fix-broken (limpieza pre-instalación)"
apt --fix-broken install -y 2>&1 | tee -a "$LOG" | tail -3

log "  → dpkg --configure -a"
dpkg --configure -a 2>&1 | tee -a "$LOG" | tail -3

log "$OK FASE 1 completada."

# ── FASE 2: Instalación de paquetes .deb locales ───────────────────────────
separador
log "\n${INFO} FASE 2: Instalando programas desde la carpeta .deb..."

DEB_DIR="$SCRIPT_DIR/programas"
mkdir -p "$DEB_DIR"

GITHUB_REPO="mnxx29/omnifish-setup"
RELEASE_URL="https://github.com/$GITHUB_REPO/releases/latest/download"

# Matriz de paquetes: "archivo.deb|url_github_release|url_oficial_directa"
PAQUETES=(
    "anydesk_8.0.4-1_amd64.deb|$RELEASE_URL/anydesk_8.0.4-1_amd64.deb|https://download.anydesk.com/linux/anydesk_8.0.4-1_amd64.deb"
    "google-chrome-stable_current_amd64.deb|$RELEASE_URL/google-chrome-stable_current_amd64.deb|https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    "ipscan_3.9.3_amd64.deb|$RELEASE_URL/ipscan_3.9.3_amd64.deb|https://github.com/angryip/ipscan/releases/download/3.9.3/ipscan_3.9.3_amd64.deb"
    "rustdesk-1.4.9-x86_64.deb|$RELEASE_URL/rustdesk-1.4.9-x86_64.deb|https://github.com/rustdesk/rustdesk/releases/download/1.4.9/rustdesk-1.4.9-x86_64.deb"
    "teamviewer_15.81.2_amd64.deb|$RELEASE_URL/teamviewer_15.81.2_amd64.deb|https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
)

descargar_deb() {
    local pkg_file="$1"
    local primary_url="$2"
    local fallback_url="$3"
    local dest="$DEB_DIR/$pkg_file"
    local temp_dest="$dest.tmp"

    if [ -f "$dest" ] && dpkg-deb -I "$dest" &>/dev/null; then
        log "  $OK Paquete verificado localmente: $pkg_file"
        return 0
    elif [ -f "$dest" ]; then
        log "  ${WARN} $pkg_file local no es un archivo .deb válido. Eliminando archivo corrupto..."
        rm -f "$dest"
    fi

    log "  ${INFO} Obteniendo $pkg_file..."

    probar_descarga() {
        local url="$1"
        [ -z "$url" ] && return 1
        rm -f "$temp_dest"

        if command -v curl &>/dev/null; then
            curl -fsSL --connect-timeout 15 --retry 2 -o "$temp_dest" "$url" 2>/dev/null || rm -f "$temp_dest"
        fi

        if [ ! -f "$temp_dest" ] && command -v wget &>/dev/null; then
            wget -q --timeout=15 --tries=2 -O "$temp_dest" "$url" 2>/dev/null || rm -f "$temp_dest"
        fi

        if [ -f "$temp_dest" ] && dpkg-deb -I "$temp_dest" &>/dev/null; then
            mv -f "$temp_dest" "$dest"
            return 0
        else
            rm -f "$temp_dest"
            return 1
        fi
    }

    # Intento 1: GitHub Releases del proyecto Omnifish
    if [ -n "$primary_url" ]; then
        if probar_descarga "$primary_url"; then
            log "  $OK Descargado con éxito desde GitHub Release ($GITHUB_REPO): $pkg_file"
            return 0
        fi
    fi

    # Intento 2: Servidores oficiales del proveedor
    if [ -n "$fallback_url" ]; then
        log "  ${WARN} Release no disponible en GitHub. Intentando servidor oficial del proveedor..."
        if probar_descarga "$fallback_url"; then
            log "  $OK Descargado con éxito desde proveedor oficial: $pkg_file"
            return 0
        fi
    fi

    log "  ${ERR} No se pudo obtener un paquete .deb válido para: $pkg_file"
    return 1
}

log "  → Verificando presencia y validez de paquetes .deb..."
for item in "${PAQUETES[@]}"; do
    IFS='|' read -r pkg_file primary_url fallback_url <<< "$item"
    descargar_deb "$pkg_file" "$primary_url" "$fallback_url" || true
done

shopt -s nullglob
DEBS=("$DEB_DIR"/*.deb)
shopt -u nullglob

if [ ${#DEBS[@]} -eq 0 ]; then
    log "$ERR No hay archivos .deb en la carpeta 'programas/'."
    exit 1
fi

log "  Archivos encontrados:"
for deb in "${DEBS[@]}"; do
    log "    • $(basename "$deb")"
done

log "\n  → Pasada 1: apt install de archivos .deb locales"
apt install -y "${DEBS[@]}" 2>&1 | tee -a "$LOG" || true

log "\n  → Pasada 2: dpkg -i de respaldo para asegurar el desempaquetado"
dpkg -i "${DEBS[@]}" 2>&1 | tee -a "$LOG" | grep -E "^Selecting|^dpkg:|error|warning" || true

log "\n  → Pasada 3: apt install -fy (resolución final de dependencias cruzadas)"
apt install -fy 2>&1 | tee -a "$LOG" | grep -E "upgraded|installed|removed|^Err" || true

log "  → fix-broken (post-instalación)"
apt --fix-broken install -y 2>&1 | tee -a "$LOG" | tail -3

log "$OK FASE 2 completada."

# ── FASE 3: Actualización instantánea 'altiro' de repositorios creados ──────
separador
log "\n${INFO} FASE 3: Actualización instantánea de programas desde sus repositorios oficiales..."

log "  → apt update (detectando los nuevos repositorios de Chrome, TeamViewer, AnyDesk, etc.)"
apt update -y 2>&1 | tee -a "$LOG" | grep -E "Get:|Ign:|Hit:|Err:" || true

log "  → apt full-upgrade (actualizando altiro los programas a la última versión en la nube)"
apt full-upgrade -y 2>&1 | tee -a "$LOG" | grep -E "upgraded|installed|removed|^Err" || true

log "  → Forzar actualización explícita de aplicaciones recién instaladas"
apt install -y --only-upgrade google-chrome-stable teamviewer anydesk rustdesk ipscan vlc 2>/dev/null || true

log "  → apt install -fy (cierre total de dependencias)"
apt install -fy 2>&1 | tee -a "$LOG" | tail -3

log "  → dpkg --configure -a"
dpkg --configure -a 2>&1 | tee -a "$LOG" | tail -3

log "  → autoremove"
apt autoremove -y 2>&1 | tee -a "$LOG" | grep -E "removed|^Err" || true

log "  → clean"
apt clean 2>&1 | tee -a "$LOG"

log "$OK FASE 3 completada."

# ── FASE 4: Desactivar Wayland (Crítico para Ubuntu 24.04 y Soporte Remoto) ───
separador
log "\n${INFO} FASE 4: Desactivando Wayland para asegurar control remoto en Ubuntu 24.04..."

CONF="/etc/gdm3/custom.conf"

if [ ! -f "$CONF" ]; then
    log "$WARN Archivo $CONF no encontrado. ¿GDM3 instalado?"
else
    if grep -E -q "^[[:space:]]*WaylandEnable=false" "$CONF"; then
        log "$OK Wayland ya estaba desactivado."
    else
        if grep -E -q "^[[:space:]]*#[[:space:]]*WaylandEnable=false" "$CONF"; then
            sed -i -E 's/^[[:space:]]*#[[:space:]]*WaylandEnable=false/WaylandEnable=false/' "$CONF"
        elif grep -q "^\[daemon\]" "$CONF"; then
            sed -i '/^\[daemon\]/a WaylandEnable=false' "$CONF"
        else
            echo -e "\n[daemon]\nWaylandEnable=false" >> "$CONF"
        fi

        if grep -E -q "^[[:space:]]*WaylandEnable=false" "$CONF"; then
            log "$OK Wayland desactivado correctamente."
        else
            log "$WARN No se encontró la línea esperada en $CONF."
            log "     Revisar manualmente: sudo nano $CONF"
        fi
    fi
fi

# ── RESUMEN FINAL Y VERIFICACIÓN ──────────────────────────────────────────────
separador
log "\n${NEGRITA}  RESUMEN DE INSTALACIÓN${RESET}"
separador

PROGRAMAS=("anydesk" "teamviewer" "rustdesk" "ipscan" "google-chrome-stable" "vlc")
NOMBRES=("AnyDesk" "TeamViewer" "RustDesk" "Angry IP Scanner" "Google Chrome" "VLC Media Player")

for i in "${!PROGRAMAS[@]}"; do
    VER=$(dpkg-query -W -f='${Version}' "${PROGRAMAS[$i]}" 2>/dev/null || echo "")
    if [ -n "$VER" ]; then
        log "  $OK ${NOMBRES[$i]} (v$VER) instalado y actualizado"
    else
        log "  $WARN ${NOMBRES[$i]} — verificar manualmente"
    fi
done

WAYLAND_STATUS=$(grep "WaylandEnable" /etc/gdm3/custom.conf 2>/dev/null | head -1 || echo "no encontrado")
log "  ${INFO} Wayland en GDM3: $WAYLAND_STATUS"

separador
log "\n${VERDE}${NEGRITA}  ¡Proceso completado con éxito!${RESET}"
log "  Log guardado en: $LOG"
log "\n${WARN} PRÓXIMOS PASOS MANUALES:"
log "  1. Reiniciar el equipo (para aplicar el cambio de Wayland a Xorg)"
log "  2. Configurar contraseñas de acceso no atendido en AnyDesk, TeamViewer y RustDesk"
log "  3. Anotar los IDs de conexión en la planilla de inventario"
log "  4. Realizar prueba de conexión remota antes de entregar el equipo"
separador

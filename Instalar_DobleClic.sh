#!/bin/bash
# ============================================================
#  Omnifish - Lanzador por Doble Clic para Ubuntu
#  Abre automáticamente la terminal pidiendo sudo y ejecuta instalar.sh
# ============================================================

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Si no es root, abre automáticamente una ventana de terminal con sudo
if [ "$EUID" -ne 0 ]; then
    if command -v gnome-terminal &>/dev/null; then
        gnome-terminal --title="Omnifish - Instalación PC" --geometry=95x28 -- bash -c "sudo bash '$DIR/instalar.sh'; echo ''; echo -e '\e[33m\e[1mPresione ENTER para cerrar esta ventana...\e[0m'; read"
        exit 0
    elif command -v x-terminal-emulator &>/dev/null; then
        x-terminal-emulator -e bash -c "sudo bash '$DIR/instalar.sh'; read"
        exit 0
    elif command -v konsole &>/dev/null; then
        konsole -e bash -c "sudo bash '$DIR/instalar.sh'; read"
        exit 0
    fi
fi

# Si ya se ejecutó con root o dentro de terminal
bash "$DIR/instalar.sh"

╔══════════════════════════════════════════════════════╗
║     Omnifish — Kit de configuración PC               ║
║     Ubuntu 24.04 LTS + Soporte Remoto                ║
╚══════════════════════════════════════════════════════╝

ESTRUCTURA:
  omnifish-setup/
  ├── Instalar_DobleClic.sh ← Lanzador rápido por DOBLE CLIC para el técnico
  ├── Instalar-Omnifish.desktop ← Acceso directo para el escritorio Ubuntu
  ├── instalar.sh          ← Script principal de instalación
  ├── README.txt           ← Este archivo
  └── programas/
      ├── anydesk_*.deb
      ├── google-chrome-stable_*.deb
      ├── teamviewer_*.deb
      ├── rustdesk_*.deb
      └── ipscan_*.deb

CÓMO USAR (PARA EL TÉCNICO EN TERRENO):
  Opción A — MÁS FÁCIL (Doble Clic directo en Ubuntu):
    1. Conectar el pendrive al PC con Ubuntu 24.04 recién instalado.
    2. Abrir la carpeta `omnifish-setup`.
    3. Hacer doble clic sobre `Instalar_DobleClic.sh` (o clic derecho → "Ejecutar como programa").
    4. Se abrirá automáticamente una ventana de terminal pidiendo la contraseña de sudo.
    5. Ingresar la contraseña y la instalación correrá sola mostrando todo en pantalla.

  Opción B — Desde Terminal (Manual):
    1. Abrir terminal en esta carpeta.
    2. Ejecutar:  sudo bash instalar.sh

EL SCRIPT HACE AUTOMÁTICAMENTE:
  ✓ Fase 0: Habilita repositorios universe/multiverse + instala librerías base de Ubuntu 24.04 y VLC Media Player
  ✓ Fase 1: apt update + full-upgrade (re-contra actualización inicial del SO)
  ✓ Fase 2: Triple pasada de instalación (.deb local + dpkg + apt install -fy)
  ✓ Fase 3: apt update + full-upgrade instantáneo ('altiro') de los repos oficiales añadidos
  ✓ Fase 4: desactiva Wayland en /etc/gdm3/custom.conf (indispensable para soporte remoto)
  ✓ Genera un log con fecha y versión exacta de los programas instalados (AnyDesk, TeamViewer, RustDesk, IP Scanner, Chrome, VLC)

LO QUE QUEDA MANUAL:
  ☐ Reiniciar el equipo
  ☐ Configurar contraseñas de acceso no atendido en AnyDesk, TeamViewer y RustDesk
  ☐ Anotar IDs en la planilla de inventario
  ☐ Prueba de conexión remota antes de entregar




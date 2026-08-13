# 🚀 Omnifish — Kit de Configuración PC (Ubuntu 24.04 LTS)

Este repositorio contiene la suite de automatización de instalación y configuración para ordenadores de trabajo con **Ubuntu 24.04 LTS**. Configura el sistema base, aplica actualizaciones completas, desactiva Wayland para garantizar el soporte remoto y gestiona la instalación de herramientas clave.

---

## 🛠️ Estructura del Repositorio

```text
omnifish-setup/
├── Instalar_DobleClic.sh       # Lanzador rápido por doble clic (Abre terminal + sudo)
├── Instalar-Omnifish.desktop   # Acceso directo para escritorio Ubuntu
├── instalar.sh                # Script principal de instalación automatizada
├── README.md                  # Documentación del proyecto
└── programas/                 # Carpeta receptora de paquetes .deb
    └── .gitkeep
```

---

## 💻 Programas Incluidos

| Programa | Versión predeterminada | Tipo |
| :--- | :--- | :--- |
| **AnyDesk** | 8.0.4-1 | Soporte Remoto |
| **TeamViewer** | 15.81.2 | Soporte Remoto |
| **RustDesk** | 1.4.9 | Soporte Remoto |
| **Angry IP Scanner** | 3.9.3 | Red / Diagnóstico |
| **Google Chrome** | Última versión estable | Navegador Web |
| **VLC Media Player** | Última versión apt | Reproductor Multimedia |

---

## 📦 Gestión de Instaladores (.deb) y GitHub Releases

Debido a que instaladores como **Google Chrome (~130 MB)** y **TeamViewer (~115 MB)** superan el límite de 100 MB por archivo de GitHub, los archivos `.deb` **no se suben directamente al código fuente de Git**.

En su lugar, los instaladores se alojan en la sección de **[GitHub Releases](https://github.com/mnxx29/omnifish-setup/releases)**:
- Si ejecutas el script desde un clon directo de Git sin los `.deb`, `instalar.sh` los **descargará automáticamente** desde la última **Release** publicada en GitHub.
- Si copias la carpeta a un **pendrive USB** con los paquetes `.deb` guardados en `programas/`, la instalación se realizará 100% **offline**.

---

## 🚀 Modo de Uso

### Opción 1: Ejecución en Ubuntu (Gráfica - Doble Clic)
1. Abre la carpeta `omnifish-setup`.
2. Haz **doble clic** sobre `Instalar_DobleClic.sh` (o clic derecho → *Ejecutar como programa*).
3. Ingresa la contraseña de superusuario (`sudo`) en la ventana emergente.

### Opción 2: Desde Terminal (Manual)
```bash
git clone https://github.com/mnxx29/omnifish-setup.git
cd omnifish-setup
sudo bash instalar.sh
```

---

## 📋 Proceso Automatizado del Script

1. **FASE 0**: Habilita repositorios `universe`/`multiverse` e instala herramientas base (`curl`, `wget`, `vlc`, etc.).
2. **FASE 1**: Ejecuta `apt update` + `full-upgrade` inicial para nivelar el sistema operativo.
3. **FASE 2**: Obtiene los archivos `.deb` (local o vía GitHub Release) y realiza triple pasada de instalación (`apt` + `dpkg` + `apt -fy`).
4. **FASE 3**: Actualización inmediata a la versión más reciente en la nube (`apt update` + `only-upgrade`).
5. **FASE 4**: Desactiva **Wayland** en `/etc/gdm3/custom.conf` (indispensable para permitir control remoto en AnyDesk/TeamViewer/RustDesk).
6. **LOG**: Genera un archivo `.log` con marca temporal en el directorio.

---

## 📝 Tareas Posteriores a la Instalación

- [ ] Reiniciar el sistema (para cambiar de Wayland a Xorg).
- [ ] Configurar clave de acceso no atendido en AnyDesk / TeamViewer / RustDesk.
- [ ] Registrar IDs de conexión en el inventario.

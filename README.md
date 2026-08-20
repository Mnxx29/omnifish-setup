# 🚀 Omnifish — Kit de Configuración PC (Ubuntu 24.04 LTS)

Este repositorio contiene la suite de automatización de instalación y configuración para ordenadores de trabajo con **Ubuntu 24.04 LTS**. Configura el sistema base, aplica actualizaciones completas, desactiva Wayland para garantizar el soporte remoto y gestiona la instalación de herramientas clave.

---

## 🛠️ Estructura del Repositorio

```text
omnifish-setup/
├── instalacion.sh             # Script principal de instalación automatizada
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
- Si ejecutas el script desde un clon directo de Git sin los `.deb`, `instalacion.sh` los **descargará automáticamente** desde la última **Release** publicada en GitHub.
- Si copias la carpeta a un **pendrive USB** con los paquetes `.deb` guardados en `programas/`, la instalación se realizará 100% **offline**.

---

## 🚀 Modo de Uso

Ejecutar desde la terminal en Ubuntu:

```bash
sudo bash instalacion.sh
```

*(O clonar y ejecutar directamente):*
```bash
git clone https://github.com/mnxx29/omnifish-setup.git
cd omnifish-setup
sudo bash instalacion.sh
```

## 📋 Proceso Automatizado del Script

1. **Auto-actualización**: Al ejecutarse en un repositorio clonado, el script realiza un `git pull` automático para obtener los últimos cambios de GitHub.
2. **FASE 0**: Habilita repositorios `universe`/`multiverse` e instala herramientas base (`git`, `curl`, `wget`, `vlc`, etc.).
3. **FASE 1**: Ejecuta `apt update` + `full-upgrade` inicial para nivelar el sistema operativo.
4. **FASE 2**: Obtiene los archivos `.deb` (local o vía GitHub Release) y realiza triple pasada de instalación (`apt` + `dpkg` + `apt -fy`).
5. **FASE 3**: Actualización inmediata a la versión más reciente en la nube (`apt update` + `only-upgrade`).
6. **FASE 4**: Desactiva **Wayland** en `/etc/gdm3/custom.conf` (indispensable para permitir control remoto en AnyDesk/TeamViewer/RustDesk).
7. **LOG**: Genera un archivo `.log` con marca temporal en el directorio.

## 📝 Tareas Posteriores a la Instalación

- [ ] Reiniciar el sistema (para cambiar de Wayland a Xorg).
- [ ] Configurar clave de acceso no atendido en AnyDesk / TeamViewer / RustDesk.
- [ ] Registrar IDs de conexión en el inventario.

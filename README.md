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
| **Hikvision SADP GUI** | Nativo Linux (`main`) | Red / Diagnóstico Cámaras IP |
| **Google Chrome** | Última versión estable | Navegador Web |
| **VLC Media Player** | Última versión apt | Reproductor Multimedia |

---

## 📦 Gestión de Instaladores (.deb) y Descargas Inteligentes

Debido a que instaladores como **Google Chrome (~130 MB)** y **TeamViewer (~115 MB)** superan el límite de 100 MB por archivo de GitHub, los paquetes `.deb` **no se suben directamente al código fuente de Git**.

El script `instalacion.sh` cuenta con un sistema inteligente de descarga con triple nivel de respaldo:
1. **Local / USB (Offline)**: Si copias la carpeta a un pendrive USB con los `.deb` guardados en `programas/`, la instalación se realiza 100% sin internet.
2. **GitHub Releases**: Si falta algún archivo local, el script intentará descargarlo desde las [Releases de GitHub](https://github.com/mnxx29/omnifish-setup/releases).
3. **Servidores Oficiales (Fallback)**: Si no hay Release publicada en GitHub, el script descargará automáticamente las versiones oficiales desde los servidores oficiales de **Google, AnyDesk, TeamViewer, RustDesk y Angry IP Scanner**.
4. **Validación automática**: Todos los archivos son verificados con `dpkg-deb` para descartar descargas corruptas o respuestas 404 antes de intentar su instalación.

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

Para abrir la herramienta de cámaras Hikvision tras la instalación:
```bash
sadp-gui
```

---

## 📋 Proceso Automatizado del Script

1. **Auto-actualización**: Al ejecutarse en un repositorio clonado, el script realiza un `git pull` automático para obtener los últimos cambios de GitHub.
2. **FASE 0**: Habilita repositorios `universe`/`multiverse` e instala herramientas base (`git`, `curl`, `wget`, `vlc`, `python3-pyqt6`, `ufw`, etc.).
3. **FASE 1**: Ejecuta `apt update` + `full-upgrade` inicial para nivelar el sistema operativo.
4. **FASE 2**: Obtiene los archivos `.deb` (local o vía GitHub Release) y realiza pasada de instalación individual por programa + resolución de dependencias.
5. **FASE 3**: Actualización inmediata a la versión más reciente en la nube (`apt update` + `only-upgrade`).
6. **FASE 4**: Despliega **Hikvision SADP GUI** en `/opt/hikvision-sadp-gui`, crea el binario global `sadp-gui`, el acceso directo `.desktop`, habilita el puerto UDP 37020 en UFW y configura `rp_filter=2` en el Kernel.
7. **FASE 5**: Desactiva **Wayland** en `/etc/gdm3/custom.conf` (indispensable para permitir control remoto en AnyDesk/TeamViewer/RustDesk).
8. **LOG & RESUMEN**: Genera un archivo `.log` detallado e imprime la tabla de verificación de programas.

## 📝 Tareas Posteriores a la Instalación

- [ ] Reiniciar el sistema (para cambiar de Wayland a Xorg).
- [ ] Configurar clave de acceso no atendido en AnyDesk / TeamViewer / RustDesk.
- [ ] Registrar IDs de conexión en el inventario.


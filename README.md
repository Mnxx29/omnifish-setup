# 🚀 Omnifish — Kit de Configuración PC (Ubuntu 24.04 LTS)

Suite de automatización para la instalación, actualización y aprovisionamiento de puestos de trabajo con **Ubuntu 24.04 LTS**. Gestiona la instalación de aplicaciones, ajustes de red, optimizaciones de kernel, deshabilitación de Wayland para soporte remoto y registro de logs en tiempo real.

---

## 💻 Aplicaciones Gestionadas

| Aplicación | Versión / Origen | Categoría |
| :--- | :--- | :--- |
| **AnyDesk** | 8.0.4-1 (`.deb`) | Soporte Remoto |
| **TeamViewer** | 15.81.2 (`.deb`) | Soporte Remoto |
| **RustDesk** | 1.4.9 (`.deb`) | Soporte Remoto |
| **Angry IP Scanner** | 3.9.3 (`.deb`) | Diagnóstico de Red |
| **Hikvision SADP GUI** | Nativo Linux (`main`) | Descubrimiento Cámaras IP |
| **Google Chrome** | Oficial Estable | Navegador Web |
| **VLC Media Player** | Repositorio Oficial `apt` | Reproductor Multimedia |

---

## 🛠️ Estructura del Proyecto

```text
omnifish-setup/
├── instalacion.sh             # Script principal de aprovisionamiento
├── README.md                  # Documentación oficial
└── programas/                 # Depósito local de paquetes .deb (Offline/Pendrive)
```

---

## 📦 Sistema de Descarga y Respaldo Inteligente

El script implementa una estrategia de adquisición de software en tres niveles:
1. **Modo Offline / USB**: Utiliza los paquetes `.deb` presentes en la carpeta `programas/`.
2. **GitHub Releases**: Si falta un paquete local, se descarga desde las [Releases del proyecto](https://github.com/mnxx29/omnifish-setup/releases).
3. **Servidores Oficiales**: Descarga directa desde los servidores oficiales del proveedor como respaldo final.

---

## 🚀 Modo de Uso

Ejecutar con privilegios de superusuario:

```bash
sudo bash instalacion.sh
```

O mediante clonación directa:

```bash
git clone https://github.com/mnxx29/omnifish-setup.git
cd omnifish-setup
sudo bash instalacion.sh
```

### Ejecución de Hikvision SADP GUI
Una vez completado el aprovisionamiento, la herramienta gráfica SADP se ejecuta mediante:

```bash
sadp-gui
```
*(También disponible en el menú de aplicaciones del sistema).*

---

## 📋 Fases del Aprovisionamiento Automatizado

1. **Sincronización Git**: Auto-actualización del código del script desde el repositorio remoto.
2. **FASE 0 — Dependencias Base**: Habilitación de repositorios `universe`/`multiverse` e instalación de utilidades clave (`python3-pyqt6`, `ufw`, `vlc`, `git`, `curl`, etc.).
3. **FASE 1 — Actualización Base**: Ejecución de `apt update` y `apt full-upgrade` con reporte de progreso en tiempo real.
4. **FASE 2 — Instalación de Programas**: Despliegue individualizado de paquetes `.deb` con retroalimentación por aplicación.
5. **FASE 3 — Sincronización Nube**: Actualización inmediata de repositorios agregados y limpieza de temporales.
6. **FASE 4 — Despliegue Hikvision SADP GUI**: Instalación en `/opt/hikvision-sadp-gui`, creación del binario global `sadp-gui`, regla UFW (UDP 37020) y configuración de Kernel (`rp_filter=2`).
7. **FASE 5 — Configuración de Entorno Gráfico**: Deshabilitación de Wayland en `/etc/gdm3/custom.conf` para compatibilidad con herramientas de control remoto.
8. **Resumen y Auditoría**: Generación de archivo `.log` con marca temporal y tabla final de validación.

---

## 📝 Tareas Post-Instalación

- [ ] Reiniciar el equipo para aplicar la transición de Wayland a Xorg.
- [ ] Configurar acceso no atendido en AnyDesk, TeamViewer y RustDesk.
- [ ] Registrar identificadores de conexión remota en el inventario.

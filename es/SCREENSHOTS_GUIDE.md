# Guía de Capturas de Pantalla

Este documento explica qué capturas de pantalla/ejemplos visuales se necesitan para la documentación.

## Capturas de Pantalla Requeridas

### 1. Proceso de Instalación (`docs/screenshots/installation.png`)

**Comando:**
```bash
bash install.sh
```

**Qué capturar:**
- El banner de bienvenida
- Prompts de instalación
- Mensajes de éxito
- Instrucciones de "próximos pasos" finales

**Herramienta ideal:** [asciinema](https://asciinema.org/) para grabación animada de terminal

### 2. Creación de Worktree (`docs/screenshots/worktree-start.gif`)

**Comando:**
```bash
/worktree-start rails "Agregar sistema de autenticación de usuario"
```

**Qué capturar:**
- Activación de smart mode
- Generación de nombre de rama por Claude
- Creación de worktree
- Generación de FEATURE.md
- Estructura de directorios después de la creación

### 3. Listado de Worktrees (`docs/screenshots/worktree-list.png`)

**Comando:**
```bash
/worktree-list
```

**Qué capturar:**
- Lista de worktrees activos
- Nombres de ramas y rutas
- Resaltado del worktree actual
- Salida limpia y colorida

### 4. Comparación de Cambios (`docs/screenshots/worktree-compare.gif`)

**Comando:**
```bash
/worktree-compare feat/user-auth
```

**Qué capturar:**
- Resumen de estadísticas (archivos cambiados, líneas agregadas/eliminadas)
- Log de commits
- Detección de conflictos (si existe)
- Vista previa de diff con resaltado de sintaxis

### 5. Proceso de Merge (`docs/screenshots/worktree-merge.gif`)

**Comando:**
```bash
/worktree-merge feat/user-auth
```

**Qué capturar:**
- Comprobaciones previas al vuelo
- Prompt de confirmación
- Ejecución de merge
- Proceso de limpieza
- Mensaje de éxito

### 6. Estructura de Directorios (`docs/screenshots/directory-structure.png`)

**Comando:**
```bash
tree -L 2 -a
```

**Qué mostrar:**
- Directorio del repositorio principal
- Directorios de worktrees hermanos
- Estructura de .claude/commands/

### 7. Comparación Antes/Después

**Crear una comparación lado a lado mostrando:**

**IZQUIERDA (Sin Worktrees):**
```
❌ Flujo Tradicional:
- git stash
- git checkout -b feat/new-feature
- *trabajar en feature*
- git checkout main
- git stash pop
- *conflictos, contexto perdido*
```

**DERECHA (Con Worktrees):**
```
✅ Con Worktrees:
- /worktree-start rails "new feature"
- *trabajar en ../feat/new-feature*
- *rama main intacta*
- /worktree-merge feat/new-feature
- ✅ Limpio, aislado, eficiente
```

## Herramientas Recomendadas

### Para Grabaciones de Terminal

1. **asciinema** (Mejor para herramientas CLI)
   ```bash
   brew install asciinema
   asciinema rec demo.cast
   # ... ejecutar comandos ...
   # Ctrl+D para detener
   asciinema play demo.cast
   ```

2. **ttygif** (Convertir a GIF)
   ```bash
   npm install -g ttygif
   ttygif demo.cast
   ```

3. **terminalizer** (Alternativa)
   ```bash
   npm install -g terminalizer
   terminalizer record demo
   terminalizer play demo
   terminalizer render demo
   ```

### Para Capturas de Pantalla

1. **macOS:** CMD+Shift+4 (selección de área)
2. **Linux:** Flameshot, gnome-screenshot
3. **Windows:** Win+Shift+S

### Para Edición

- **ImageMagick** para procesamiento por lotes
- **Gimp** para edición avanzada
- **Carbon.now.sh** para capturas de código bonitas

## Estructura de Directorios

Crear esta estructura de directorios:

```
docs/
├── screenshots/
│   ├── installation.png
│   ├── worktree-start.gif
│   ├── worktree-list.png
│   ├── worktree-compare.gif
│   ├── worktree-merge.gif
│   ├── directory-structure.png
│   └── before-after.png
└── examples/
    ├── example-output-start.txt
    ├── example-output-list.txt
    ├── example-output-compare.txt
    └── example-output-merge.txt
```

## Cómo Agregar Capturas de Pantalla a la Documentación

### En README.md

Agregar después de la sección "Quick Start":

```markdown
## Vista General Visual

### Instalación

![Proceso de Instalación](docs/screenshots/installation.png)

### Crear un Worktree

![Creación de Worktree](docs/screenshots/worktree-start.gif)

### Gestión de Worktrees

![Lista de Worktrees](docs/screenshots/worktree-list.png)
```

### En START_HERE.md

Agregar a la sección "Quick Start de 60 Segundos":

```markdown
Así se ve en acción:

![Demo Rápida](docs/screenshots/worktree-start.gif)
```

## Archivos de Salida de Ejemplo

He creado archivos de salida de ejemplo en formato markdown que se pueden usar hasta que las capturas de pantalla reales estén disponibles:

- `docs/examples/example-output-*.txt`

Estos proporcionan ejemplos basados en texto de salida de comandos que se pueden incrustar en la documentación.

## Crear Entorno de Demo

Para crear capturas de pantalla, configura un entorno de demo:

```bash
# 1. Crear app Rails de demo
rails new demo-app
cd demo-app
git init
git add .
git commit -m "Initial commit"

# 2. Instalar comandos de worktree
mkdir -p .claude/commands
cp /path/to/worktree-*.md .claude/commands/

# 3. Iniciar grabación
asciinema rec demo.cast

# 4. Ejecutar comandos
/worktree-start rails "Agregar autenticación de usuario"
cd ../feat/add-user-authentication
# Hacer algunos cambios
echo "# Authentication" >> AUTH.md
git add . && git commit -m "Agregar documentación de auth"
cd ../demo-app
/worktree-compare feat/add-user-authentication
/worktree-merge feat/add-user-authentication

# 5. Detener grabación (Ctrl+D)

# 6. Convertir a GIF
ttygif demo.cast
```

## Badge de Placeholder para README

Hasta que las capturas de pantalla reales estén disponibles, agrega este badge:

```markdown
[![Screencast](https://img.shields.io/badge/screencast-coming%20soon-yellow)](docs/screenshots/)
```

## Próximos Pasos

1. [ ] Configurar entorno de demo
2. [ ] Grabar todas las demostraciones de comandos
3. [ ] Crear capturas de pantalla/GIFs
4. [ ] Agregar a la documentación
5. [ ] Verificar que todos los enlaces funcionen
6. [ ] Actualizar badge para mostrar disponible

# Contribuir a Claude Code Worktree Commands

Gracias por tu interés en contribuir! Este documento proporciona directrices para contribuir a este proyecto.

## Código de Conducta

Al participar en este proyecto, aceptas:
- Ser respetuoso e inclusivo
- Dar la bienvenida a los recién llegados y ayudarles a aprender
- Enfocarte en retroalimentación constructiva
- Priorizar el bienestar de la comunidad

## Cómo Puedo Contribuir?

### Reportar Bugs

Antes de crear reportes de bugs, verifica los issues existentes para evitar duplicados. Al crear un reporte de bug, incluye:

- **Descripción clara** del problema
- **Pasos para reproducir** el comportamiento
- **Comportamiento esperado** vs lo que realmente ocurrió
- **Detalles del entorno**: SO, versión de Git, versión de Claude Code
- **Capturas de pantalla** si aplica

Usa la plantilla de reporte de bugs al crear issues.

### Sugerir Mejoras

Las sugerencias de mejoras son bienvenidas! Por favor:

- Usa un título claro y descriptivo
- Proporciona una descripción detallada de la mejora sugerida
- Explica por qué esta mejora sería útil
- Proporciona ejemplos de cómo funcionaría

Usa la plantilla de solicitud de features al crear issues.

### Contribuciones de Código

#### Configuración de Desarrollo

1. **Haz fork del repositorio**
   ```bash
   # Fork vía interfaz de GitHub, luego clona tu fork
   git clone https://github.com/TU-USUARIO/worktree-claude-code-commands.git
   cd worktree-claude-code-commands
   ```

2. **Crea un entorno de pruebas**
   ```bash
   # Crea un repositorio git de prueba para probar comandos
   cd /tmp
   mkdir test-repo
   cd test-repo
   git init
   echo "# Test" > README.md
   git add . && git commit -m "Initial commit"
   ```

3. **Instala los comandos localmente**
   ```bash
   # Copia al repositorio de prueba
   mkdir -p .claude/commands
   cp /path/to/worktree-claude-code-commands/worktree-*.md .claude/commands/
   ```

4. **Prueba tus cambios** usando Claude Code en el repositorio de prueba

#### Haciendo Cambios

1. **Crea una rama de feature** desde `main`
   ```bash
   git checkout -b feat/tu-nombre-de-feature
   ```

2. **Haz tus cambios**
   - Sigue el estilo de código y convenciones existentes
   - Mantén los cambios enfocados y atómicos
   - Escribe mensajes de commit claros y descriptivos

3. **Prueba exhaustivamente**
   - Prueba los cuatro slash commands
   - Prueba casos extremos y condiciones de error
   - Prueba en proyectos Rails y WordPress si aplica

4. **Actualiza la documentación**
   - Actualiza README.md si agregas features
   - Actualiza CHEATSHEET.md para nuevos workflows
   - Agrega comentarios en archivos de comandos para lógica compleja

#### Directrices de Mensajes de Commit

Usa formato de commit convencional:

```
tipo(alcance): asunto

cuerpo (opcional)

pie (opcional)
```

**Tipos:**
- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Solo documentación
- `style`: Formato, punto y coma faltantes, etc.
- `refactor`: Reestructuración de código sin cambio de comportamiento
- `test`: Agregar tests faltantes
- `chore`: Tareas de mantenimiento

**Ejemplos:**
```
feat(worktree-start): agregar soporte para rama base personalizada

fix(worktree-merge): prevenir eliminación de rama main

docs(readme): aclarar pasos de instalación para usuarios Windows
```

#### Proceso de Pull Request

1. **Actualiza tu rama** con el último main
   ```bash
   git fetch origin
   git rebase origin/main
   ```

2. **Push a tu fork**
   ```bash
   git push origin feat/tu-nombre-de-feature
   ```

3. **Crea Pull Request**
   - Usa un título claro y descriptivo
   - Completa la plantilla de PR completamente
   - Vincula issues relacionados usando palabras clave (Fixes #123)
   - Solicita revisión de los mantenedores

4. **Responde a la retroalimentación**
   - Atien todos los comentarios de revisión
   - Haz push de commits adicionales si es necesario
   - Marca conversaciones como resueltas

5. **Squash y merge** (los mantenedores se encargarán de esto)

### Mejorar la Documentación

Las mejoras de documentación son muy valiosas! Puedes ayudar:

- Corrigiendo errores tipográficos o lenguaje poco claro
- Agregando ejemplos para casos de uso comunes
- Traduciendo documentos a otros idiomas
- Agregando diagramas o ayudas visuales
- Mejorando mensajes de error

### Agregar Soporte de Idiomas

Actualmente soporta Rails y WordPress. Para agregar soporte para otro stack:

1. **Estudia las implementaciones existentes** en archivos de comandos
2. **Identifica patrones específicos del stack** (nomenclatura, estructura, herramientas)
3. **Agrega lógica condicional** a los comandos
4. **Actualiza documentación** con nuevos ejemplos
5. **Prueba exhaustivamente** con proyectos reales

## Estructura del Proyecto

```
worktree-claude-code-commands/
├── install.sh              # Script de instalación
├── worktree-start.md       # Comando: Crear worktree
├── worktree-list.md        # Comando: Listar worktrees
├── worktree-compare.md     # Comando: Comparar cambios
├── worktree-merge.md       # Comando: Merge y cleanup
├── README.md               # Documentación principal
├── START_HERE.md           # Guía de inicio rápido
├── CHEATSHEET.md           # Referencia rápida
├── MANIFEST.md             # Inventario del proyecto
├── LICENSE                 # Licencia MIT
└── CONTRIBUTING.md         # Este archivo
```

## Estructura de Archivos de Comandos

Cada archivo de slash command sigue esta estructura:

```markdown
---
description: Descripción breve para Claude Code
allowed-tools: [bash_tool]
---

# Título del Comando

Explicación breve de lo que hace el comando.

**Uso:** `/nombre-comando [args]`

## Validación
Comprobaciones previas al vuelo antes de ejecución

## Proceso
Lógica de ejecución paso a paso

### 1. Nombre del Paso
Bloques de código bash con comentarios detallados

### 2. Siguiente Paso
...

## Manejo de Errores
Cómo manejar varias condiciones de error

## Rollback
Cómo deshacer si algo sale mal
```

## Directrices de Estilo

### Código Bash

- Usa shebang `#!/usr/bin/env bash` (si son scripts standalone)
- Entrecomilla todas las expansiones de variables: `"$VARIABLE"`
- Usa `[[ ]]` para condicionales en lugar de `[ ]`
- Verifica códigos de salida: `if [ $? -ne 0 ]; then`
- Agrega manejo de errores para todas las operaciones críticas
- Usa nombres de variables descriptivos en MAYÚSCULAS

### Documentación

- Usa lenguaje claro y conciso
- Incluye ejemplos prácticos
- Formatea bloques de código con etiquetas de lenguaje apropiadas
- Usa emojis con moderación y significado (✅ ❌ 🚀 💡)
- Mantén la longitud de línea bajo 100 caracteres

### Markdown

- Usa encabezados ATX (#) no Setext (subrayados)
- Deja líneas en blanco alrededor de encabezados y bloques de código
- Usa bloques de código delimitados (```) con etiquetas de lenguaje
- Usa links de estilo referencia para URLs repetidas

## Checklist de Pruebas

Antes de enviar un PR, verifica:

- [ ] Todos los comandos funcionan en entorno de prueba
- [ ] El manejo de errores funciona correctamente
- [ ] La documentación está actualizada
- [ ] Los mensajes de commit siguen la convención
- [ ] No hay información sensible en los commits
- [ ] El código está comentado donde es complejo
- [ ] Los ejemplos están probados y funcionan
- [ ] Los enlaces en la documentación son válidos

## Obtener Ayuda

- **¿Preguntas?** Abre una GitHub Discussion
- **¿Atascado?** Comenta en tu PR para pedir ayuda
- **¿No estás seguro?** Abre un draft PR temprano para retroalimentación

## Reconocimiento

Los contribuidores serán:
- Listados en la sección de contribuidores de README.md
- Mencionados en las notas de lanzamiento
- Acreditados en el historial de commits

Gracias por hacer mejor este proyecto! 🙏

---

**Recuerda:** Las buenas contribuciones no tienen que ser grandes. Corregir errores tipográficos, mejorar documentación o agregar ejemplos son todos valiosos!

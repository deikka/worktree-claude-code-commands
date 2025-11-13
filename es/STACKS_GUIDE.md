# Guía de Configuración de Stacks

Esta guía explica cómo usar comandos de worktree con diferentes stacks tecnológicos y cómo agregar soporte para nuevos.

---

## Stacks Soportados

De fábrica, el sistema soporta:

### Soporte Optimizado (Funcionalidades Completas)

- **Rails** - Ruby on Rails con comprobaciones específicas de Rails completas
- **WordPress** - WordPress con WordPlate, incluyendo comprobaciones de theme/plugin

### Soporte Integrado (Funcionalidades Estándar)

- **Node.js** - Proyectos JavaScript/TypeScript
- **Python** - Proyectos Python
- **Go** - Proyectos Go
- **Rust** - Proyectos Rust
- **Generic** - Cualquier otro tipo de proyecto

---

## Usar Diferentes Stacks

### Sintaxis

```bash
/worktree-start <stack> "descripción de feature"
```

### Ejemplos

```bash
# Proyecto Rails
/worktree-start rails "Agregar autenticación de usuario"
# Crea: feat/user-authentication

# Proyecto WordPress
/worktree-start wordpress "Agregar formulario de contacto"
# Crea: feature/contact-form

# Proyecto Node.js
/worktree-start node "Implementar servidor websocket"
# Crea: feat/websocket-server

# Proyecto Python
/worktree-start python "Agregar entrenamiento de modelo ML"
# Crea: feat/ml-model-training

# Proyecto Go
/worktree-start go "Optimizar consultas de base de datos"
# Crea: feat/optimize-db-queries

# Proyecto genérico
/worktree-start generic "Nueva feature"
# Crea: feat/new-feature
```

### Alias

Puedes usar formas cortas:

```bash
/worktree-start js "feature"      # Igual que 'node'
/worktree-start ts "feature"      # Igual que 'node'
/worktree-start py "feature"      # Igual que 'python'
/worktree-start wp "feature"      # Igual que 'wordpress'
```

---

## Funcionalidades Específicas del Stack

### Rails (Totalmente Optimizado)

**Convenciones de ramas:**
- Features: `feat/*`
- Bugfixes: `fix/*`
- Refactors: `refactor/*`
- Hotfixes: `hotfix/*`

**Comprobaciones automáticas:**
- ✅ Detección de migraciones de base de datos
- ✅ Conflictos de rutas
- ✅ Validación de credenciales
- ✅ Cobertura de tests

**FEATURE.md incluye:**
- Estructura de modelos, controladores, vistas
- Pasos de migración
- Requisitos de tests
- Consideraciones de seguridad

### WordPress (Totalmente Optimizado)

**Convenciones de ramas:**
- Features: `feature/*`
- Bugfixes: `bugfix/*`
- Enhancements: `enhancement/*`
- Hotfixes: `hotfix/*`

**Comprobaciones automáticas:**
- ✅ Estructura de theme/plugin
- ✅ Compilación de assets
- ✅ Cambios en base de datos
- ✅ Validación de hooks de WordPress

**FEATURE.md incluye:**
- Estructura de plugin/theme
- Hooks de WordPress necesarios
- Archivos de template
- Consideraciones de interfaz de admin

### Node.js (Soporte Estándar)

**Convenciones de ramas:**
- Features: `feat/*`
- Bugfixes: `fix/*`

**Comprobaciones automáticas:**
- ✅ Cambios en package.json
- ✅ Conflictos de dependencias
- ✅ Validación de build

**FEATURE.md incluye:**
- Sugerencias de estructura de archivos
- Dependencias a considerar
- Enfoque de testing

### Python (Soporte Estándar)

**Convenciones de ramas:**
- Features: `feat/*`
- Bugfixes: `fix/*`

**Comprobaciones automáticas:**
- ✅ Cambios en requirements.txt
- ✅ Validación de imports
- ✅ Estructura de tests

**FEATURE.md incluye:**
- Estructura de módulos
- Dependencias
- Enfoque de testing

### Go (Soporte Estándar)

**Convenciones de ramas:**
- Features: `feat/*`
- Bugfixes: `fix/*`

**Comprobaciones automáticas:**
- ✅ Cambios en go.mod
- ✅ Validación de build
- ✅ Cobertura de tests

**FEATURE.md incluye:**
- Estructura de paquetes
- Diseño de interfaces
- Enfoque de testing

### Rust (Soporte Estándar)

**Convenciones de ramas:**
- Features: `feat/*`
- Bugfixes: `fix/*`

**Comprobaciones automáticas:**
- ✅ Cambios en Cargo.toml
- ✅ Advertencias de Clippy
- ✅ Cobertura de tests

**FEATURE.md incluye:**
- Estructura de módulos
- Consideraciones de ownership
- Enfoque de testing

### Generic (Soporte Básico)

**Convenciones de ramas:**
- Features: `feat/*`
- Bugfixes: `fix/*`
- Docs: `docs/*`
- Tests: `test/*`

**Comprobaciones automáticas:**
- ✅ Solo validación básica de git

**FEATURE.md incluye:**
- Guía de implementación genérica
- Consejos de organización de archivos
- Recordatorios de testing

---

## Archivo de Configuración

Los comportamientos de stacks se definen en `.worktree-config.json`. Este archivo está incluido con el sistema y define:

- Convenciones de nomenclatura de ramas
- Comprobaciones específicas del stack
- Sugerencias de archivos para FEATURE.md
- Comportamientos por defecto

### Ejemplo de Entrada de Configuración

```json
{
  "stacks": {
    "python": {
      "name": "Python",
      "branch_prefix": "feat",
      "branch_patterns": {
        "feature": "feat",
        "bugfix": "fix",
        "refactor": "refactor"
      },
      "checks": [
        "dependencies",
        "tests",
        "linting"
      ],
      "suggested_files": [
        "src/**/*.py",
        "tests/**/*.py",
        "requirements.txt"
      ]
    }
  }
}
```

---

## Personalizar para Tu Proyecto

### Opción 1: Crear Override Local

Crea `.worktree-config.local.json` en la raíz de tu proyecto:

```json
{
  "stacks": {
    "rails": {
      "branch_prefix": "feature",
      "branch_patterns": {
        "feature": "feature",
        "bugfix": "bugfix"
      }
    }
  }
}
```

Esto sobrescribirá la configuración de Rails por defecto solo para tu proyecto.

### Opción 2: Agregar Stack Personalizado

Crea `.worktree-config.local.json`:

```json
{
  "stacks": {
    "flutter": {
      "name": "Flutter",
      "branch_prefix": "feat",
      "branch_patterns": {
        "feature": "feat",
        "bugfix": "fix"
      },
      "checks": [
        "dependencies",
        "tests",
        "build"
      ],
      "suggested_files": [
        "lib/**/*.dart",
        "test/**/*.dart",
        "pubspec.yaml"
      ]
    }
  }
}
```

Luego úsalo:

```bash
/worktree-start flutter "Agregar pantalla de autenticación"
```

---

## Agregar Soporte Completo para Nuevos Stacks

Para agregar soporte integral para un nuevo stack (con todas las optimizaciones):

### 1. Definir Configuración

Agrega a `.worktree-config.json` o crea override local:

```json
{
  "stacks": {
    "tu-stack": {
      "name": "Nombre de Tu Stack",
      "branch_prefix": "feat",
      "branch_patterns": {
        "feature": "feat",
        "bugfix": "fix"
      },
      "checks": [
        "tus-comprobaciones-específicas"
      ],
      "suggested_files": [
        "path/to/**/*.ext"
      ]
    }
  }
}
```

### 2. Actualizar Archivos de Comandos (Opcional)

Para integración profunda, agrega lógica específica del stack a archivos de comandos:

**En `worktree-start.md`:**

```bash
# Agrega tu stack a validación
if [[ "$STACK" == "tu-stack" ]]; then
  echo "🎯 Proyecto Tu Stack detectado"
  # Agrega configuración específica...
fi
```

**En `worktree-compare.md`:**

```bash
# Agrega comprobaciones específicas de tu stack
if [[ "$STACK" == "tu-stack" ]]; then
  echo "🔧 COMPROBACIONES ESPECÍFICAS DE TU-STACK"
  # Agrega comprobaciones...
fi
```

### 3. Documentarlo

Agrega documentación a `STACKS_GUIDE.md` (este archivo) con:
- Convenciones de ramas
- Comprobaciones automáticas
- Contenido de FEATURE.md
- Ejemplos

### 4. Contribuir de Vuelta

Si agregas soporte para un stack popular, considera:
1. Probar exhaustivamente
2. Crear un PR para agregarlo al proyecto principal
3. Agregar ejemplos y documentación

---

## Detección de Stack (Funcionalidad Futura)

En versiones futuras, podemos agregar detección automática de stack:

```bash
# Detecta automáticamente el stack desde archivos del proyecto
/worktree-start auto "descripción de feature"

# Lógica de detección:
# - Gemfile + config/application.rb → Rails
# - package.json + node_modules → Node
# - requirements.txt + *.py → Python
# - go.mod → Go
# - Cargo.toml → Rust
# - wp-config.php → WordPress
```

---

## Mejores Prácticas

### 1. Elegir el Tipo de Stack Correcto

- Usa **stack específico** (rails, node, python) cuando esté disponible
- Usa **generic** solo para proyectos no estándar
- Crea **stack personalizado** para uso repetido

### 2. Mantener Consistencia

Dentro de un proyecto, siempre usa el mismo identificador de stack:

```bash
# Bueno - consistente
/worktree-start node "Feature A"
/worktree-start node "Feature B"

# Malo - inconsistente
/worktree-start node "Feature A"
/worktree-start generic "Feature B"
```

### 3. Documentar Stacks Personalizados

Si creas stacks personalizados, documéntalos en el README de tu proyecto:

```markdown
## Comandos Worktree

Este proyecto usa configuración personalizada de worktree:

\`\`\`bash
# Usa stack 'flutter' para este proyecto
/worktree-start flutter "descripción de feature"
\`\`\`
```

---

## Ejemplos por Caso de Uso

### Monorepo con Múltiples Stacks

```bash
# Backend (Node.js)
/worktree-start node "Agregar API GraphQL"

# Frontend (React)
/worktree-start node "Agregar dashboard de usuario"

# Mobile (necesitaría stack personalizado)
/worktree-start flutter "Agregar pantalla de login"
```

### Microservicios

```bash
# Servicio A (Go)
/worktree-start go "Agregar servicio de autenticación"

# Servicio B (Python)
/worktree-start python "Agregar servicio de predicción ML"

# Servicio C (Rust)
/worktree-start rust "Agregar caché de alto rendimiento"
```

### Proyecto Full-Stack

```bash
# API Backend Rails
/worktree-start rails "Agregar autenticación JWT"

# Frontend Next.js
/worktree-start node "Agregar UI de login"

# Documentación Compartida
/worktree-start generic "Actualizar documentación de API"
```

---

## Troubleshooting

### Error "Unknown stack"

Si obtienes un error sobre stack desconocido:

1. Verifica ortografía: `rails` no `rail`, `node` no `nodejs`
2. Usa `generic` como respaldo: `/worktree-start generic "feature"`
3. Crea configuración de stack personalizado

### Nomenclatura de rama no coincide con expectativas

Sobrescribe en `.worktree-config.local.json`:

```json
{
  "stacks": {
    "rails": {
      "branch_prefix": "tu-prefijo"
    }
  }
}
```

### Faltan comprobaciones específicas del stack

Esto es normal para stacks integrados (node, python, etc.). Para agregar más comprobaciones:

1. Crea configuración personalizada
2. O contribuye al proyecto principal con soporte mejorado

---

## Contribuir Nuevos Stacks

Damos la bienvenida a contribuciones para soporte de nuevos stacks! Ver [CONTRIBUTING.md](CONTRIBUTING.md) para:

- Cómo proponer nuevos stacks
- Requisitos de testing
- Estándares de documentación
- Proceso de pull request

**Stacks prioritarios para contribuciones:**
- Swift/desarrollo iOS
- Kotlin/desarrollo Android
- C#/.NET
- Java/Spring
- PHP (no WordPress)
- Elixir/Phoenix

---

## Referencia

### Lista Completa de Stacks

| Stack      | Alias    | Prefijo de Rama | Estado              |
|------------|----------|-----------------|---------------------|
| rails      | -        | feat            | ✅ Totalmente Optimizado  |
| wordpress  | wp       | feature         | ✅ Totalmente Optimizado  |
| node       | js, ts   | feat            | ✅ Soporte Integrado |
| python     | py       | feat            | ✅ Soporte Integrado |
| go         | golang   | feat            | ✅ Soporte Integrado |
| rust       | rs       | feat            | ✅ Soporte Integrado |
| generic    | -        | feat            | ✅ Soporte Básico    |

### Prioridad de Configuración

1. `.worktree-config.local.json` (específico del proyecto, prioridad más alta)
2. `.worktree-config.json` (valores por defecto del sistema)
3. Respaldos hard-coded en comandos (prioridad más baja)

---

¿Necesitas ayuda? [Abre un issue](https://github.com/deikka/worktree-claude-code-commands/issues) o verifica [README.md](README.md) para más información.

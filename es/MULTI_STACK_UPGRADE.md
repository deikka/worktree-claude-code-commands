# Actualización de Soporte Multi-Stack

Este documento explica el soporte multi-stack agregado al sistema Git Worktrees para Claude Code.

## ¿Qué Cambió?

El sistema ahora soporta **múltiples stacks tecnológicos** más allá de solo Rails y WordPress:

### Anteriormente (v1.0.0-alpha)
```bash
# Solo soportado:
/worktree-start rails "feature"
/worktree-start wp "feature"
```

### Ahora (v1.0.0)
```bash
# Soporte totalmente optimizado:
/worktree-start rails "feature"
/worktree-start wordpress "feature"

# Soporte integrado:
/worktree-start node "feature"
/worktree-start python "feature"
/worktree-start go "feature"
/worktree-start rust "feature"

# Respaldo genérico:
/worktree-start generic "feature"

# Extensible:
# ¡Agrega tus propias configuraciones de stack!
```

## Nuevas Funcionalidades

### 1. Sistema de Configuración

**Archivo:** `.worktree-config.json`

Define comportamientos específicos del stack:
- Convenciones de nomenclatura de ramas
- Comprobaciones específicas del stack
- Archivos sugeridos para FEATURE.md
- Comportamientos por defecto

### 2. Overrides Locales

**Archivo:** `.worktree-config.local.json` (opcional)

Sobrescribe configuraciones por defecto para tu proyecto:

```json
{
  "stacks": {
    "rails": {
      "branch_prefix": "feature"
    }
  }
}
```

### 3. Stacks Personalizados

Agrega tu propio soporte de stack:

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
      "checks": ["dependencies", "tests", "build"],
      "suggested_files": ["lib/**/*.dart", "test/**/*.dart"]
    }
  }
}
```

Luego úsalo:
```bash
/worktree-start flutter "Agregar pantalla de autenticación"
```

## Guía de Migración

### Si Usabas Rails

**No se necesitan cambios!** Tu uso existente continúa funcionando:

```bash
/worktree-start rails "descripción de feature"
```

### Si Usabas WordPress

**Cambio menor:** Usa `wordpress` en lugar de `wp` (aunque `wp` todavía funciona como alias):

```bash
# Ambos funcionan:
/worktree-start wordpress "feature"
/worktree-start wp "feature"  # Alias
```

### Si Quieres Usar Otros Stacks

Simplemente usa los nuevos nombres de stack:

```bash
/worktree-start node "feature"
/worktree-start python "feature"
/worktree-start go "feature"
/worktree-start rust "feature"
/worktree-start generic "feature"  # Para cualquier otra cosa
```

## Beneficios

### 1. Adopción Más Amplia

El sistema ya no está limitado a desarrolladores Rails/WordPress. ¡Cualquiera puede usarlo!

### 2. Convenciones Inteligentes

Cada stack obtiene nomenclatura de rama apropiada:
- Rails: `feat/*`, `fix/*`, `refactor/*`
- WordPress: `feature/*`, `bugfix/*`, `enhancement/*`
- Node/Python/Go/Rust: `feat/*`, `fix/*`
- Generic: `feat/*`, `fix/*`, `docs/*`, `test/*`

### 3. Comprobaciones Específicas del Stack

Las comparaciones incluyen comprobaciones relevantes:
- Rails: Migraciones, rutas, credenciales
- WordPress: Themes, plugins, assets
- Node: Dependencias, build
- Python: Dependencias, imports
- Go: Dependencias, build
- Rust: Dependencias, clippy

### 4. Extensibilidad

Agrega soporte para TU stack sin modificar archivos core:

```bash
# 1. Crea .worktree-config.local.json
# 2. Agrega tu definición de stack
# 3. ¡Úsalo inmediatamente!
```

## Documentación

- **[STACKS_GUIDE.md](STACKS_GUIDE.md)** - Guía completa de todos los stacks
- **[README.md](README.md)** - Actualizado con ejemplos multi-stack
- **[.worktree-config.json](.worktree-config.json)** - Configuraciones por defecto

## Compatibilidad Hacia Atrás

**100% compatible** con uso existente:

- Todos los comandos Rails funcionan exactamente como antes
- Todos los comandos WordPress funcionan exactamente como antes
- Generación de FEATURE.md sin cambios para Rails/WordPress
- No se requiere configuración para usuarios existentes

## ¿Qué Sigue?

### Inmediato (v1.0.0)
- [x] Soporte multi-stack
- [x] Sistema de configuración
- [x] Documentación

### Futuro (v1.1.0+)
- [ ] Detección automática de stack
- [ ] Más stacks optimizados (Swift, Kotlin, Elixir, etc.)
- [ ] Compartir configuración a nivel de equipo
- [ ] Marketplace de templates de stack

## ¿Preguntas?

- Ver [STACKS_GUIDE.md](STACKS_GUIDE.md) para uso detallado
- Ver [.worktree-config.json](.worktree-config.json) para ejemplos de configuración
- Abre un [issue](https://github.com/deikka/worktree-claude-code-commands/issues) si necesitas ayuda

---

**¡Esto hace que el sistema sea útil para CUALQUIER desarrollador, no solo devs Rails/WordPress!** 🎉

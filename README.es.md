# Git Worktrees for Claude Code

Sistema completo de gestión de git worktrees optimizado para desarrollo paralelo con Claude Code.

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 📖 Tabla de Contenidos

- [¿Qué es esto?](#qué-es-esto)
- [¿Por qué usar worktrees?](#por-qué-usar-worktrees)
- [Instalación](#instalación)
- [Quick Start](#quick-start)
- [Comandos Disponibles](#comandos-disponibles)
- [Documentación Completa](#documentación-completa)
- [Workflows](#workflows)
- [Best Practices](#best-practices)
- [FAQ](#faq)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

---

## ¿Qué es esto?

Un conjunto de **slash commands para Claude Code** que hacen el trabajo con git worktrees increíblemente fácil e intuitivo.

**Los worktrees** te permiten tener múltiples checkouts del mismo repositorio git simultáneamente. En lugar de hacer stash/switch/pop constantemente, puedes trabajar en múltiples features al mismo tiempo, cada una en su propio directorio.

**Este sistema** elimina toda la complejidad de gestionar worktrees manualmente, proporcionando:

✅ Creación inteligente de worktrees con AI assistance  
✅ Comparación visual de cambios antes de merge  
✅ Merge seguro con cleanup automático  
✅ Gestión y mantenimiento sin fricción  
✅ Soporte específico para Rails y WordPress

---

## ¿Por qué usar worktrees?

### Problema Tradicional

```bash
# Estás trabajando en feature A
git checkout -b feature-a
# ... haciendo cambios ...

# OH NO! Bug urgente
git stash                # Guardar cambios
git checkout main        # Cambiar rama
git checkout -b hotfix   # Nueva rama
# ... arreglar bug ...
git checkout feature-a   # Volver
git stash pop            # Recuperar cambios
# ¡Conflictos con el stash! 😱
```

### Solución con Worktrees

```bash
# Terminal 1: Trabajando en feature A
/worktree-start rails "Feature A"
cd ../feat/feature-a
# ... haciendo cambios tranquilamente ...

# Terminal 2: Bug urgente
/worktree-start rails "Hotfix"
cd ../hotfix/urgent-bug
# ... arreglas el bug ...
/worktree-merge main

# Terminal 1: Sigues trabajando sin interrupciones
# No stash, no conflictos, no estrés ✨
```

### Beneficios Clave

1. **Desarrollo paralelo real** - Múltiples features al mismo tiempo
2. **Zero context switching** - Cada feature en su propio espacio
3. **Tests independientes** - Prueba una feature sin afectar otras
4. **Hotfixes sin interrupción** - Arregla bugs sin tocar tu trabajo actual
5. **Code review fácil** - Checkout de branches de colegas sin stash
6. **Experimentación segura** - Prueba ideas sin riesgo

---

## Instalación

### Prerrequisitos

- Git 2.15+ (para worktrees)
- Claude Code instalado
- Proyecto git existente
- Rails 8.0+ o WordPress/PHP 8.2+ (opcional pero recomendado)

### Pasos

```bash
# 1. Descarga o clona este repositorio
cd /path/to/tu/proyecto

# 2. Copia los archivos del sistema a tu proyecto
cp -r /path/to/worktree-commands/* .

# 3. Ejecuta el instalador
chmod +x install.sh
./install.sh

# ¡Listo! Los comandos están disponibles en Claude Code
```

### Verificación

```bash
# En Claude Code, prueba:
/worktree-list

# Deberías ver output sin errores
```

### Actualización

```bash
# Para actualizar los comandos
./install.sh

# Confirma overwrite cuando se pregunte
```

---

## Quick Start

### 5 Minutos a tu Primer Worktree

```bash
# 1. Crear worktree (smart mode)
/worktree-start rails "Add JWT authentication with refresh tokens"

# 2. Navegar y trabajar
cd ../feat/jwt-auth-refresh-tokens
cat FEATURE.md  # Leer guía generada por Claude
# ... código, commits ...

# 3. Comparar antes de merge
/worktree-compare main

# 4. Testear
bin/rails test  # O tu comando de tests

# 5. Merge y cleanup
/worktree-merge main

# ¡Feature completa! 🎉
```

### Comando Más Común (80% de uso)

```bash
/worktree-start [rails|wp] "Descripción de tu feature"
```

**Smart Mode Features:**
- Claude analiza tu descripción
- Genera nombre de rama automáticamente
- Crea `FEATURE.md` con checklist y context
- Sugiere archivos relevantes para empezar

---

## Comandos Disponibles

### `/worktree-start` - Crear worktree

**Sintaxis:**
```bash
/worktree-start [rails|wp] "feature description"  # Smart mode (recomendado)
/worktree-start [rails|wp] branch-name           # Manual mode
```

**Ejemplos:**
```bash
# Rails smart mode
/worktree-start rails "Add OAuth2 authentication with Google and GitHub"
# → Crea: feat/oauth2-auth-google-github + FEATURE.md

# WordPress manual mode
/worktree-start wp custom-widget
# → Crea: custom-widget (sin FEATURE.md)
```

**Qué hace:**
1. Valida proyecto tipo y estado
2. (Smart) Claude genera nombre de rama apropiado
3. Crea nuevo worktree en directorio sibling
4. (Smart) Genera `FEATURE.md` con guía completa
5. Setup tracking branch en remote

**[Documentación completa →](./worktree-start.md)**

---

### `/worktree-compare` - Comparar antes de merge

**Sintaxis:**
```bash
/worktree-compare [target-branch]  # Default: main/master auto-detect
```

**Ejemplos:**
```bash
# Comparar con main
/worktree-compare

# Comparar con develop
/worktree-compare develop
```

**Qué muestra:**
- 📊 Resumen de cambios (files, +lines, -lines)
- 📝 Lista de commits
- ⚠️ Detección de conflictos potenciales
- 📋 Diff completo para review

**[Documentación completa →](./worktree-compare.md)**

---

### `/worktree-merge` - Merge y cleanup

**Sintaxis:**
```bash
/worktree-merge [target-branch]  # Default: main/master auto-detect
```

**Ejemplo:**
```bash
/worktree-merge main
```

**Qué hace (todo automático):**
1. ✅ Valida estado (uncommitted changes check)
2. 🔀 Merge a target branch
3. ⬆️ Push a remote
4. 🗑️ Elimina worktree directory
5. 🌿 Borra rama local/remote
6. 📍 Te deja en main branch

**⚠️ IMPORTANTE:** Siempre usa `/worktree-compare` antes de merge.

**[Documentación completa →](./worktree-merge.md)**

---

### `/worktree-list` - Listar y gestionar

**Sintaxis:**
```bash
/worktree-list              # Listar worktrees activos
/worktree-list cleanup      # Eliminar worktrees mergeados
/worktree-list prune        # Limpiar referencias stale
```

**Ejemplos:**
```bash
# Ver estado actual
/worktree-list

# Limpieza después de merges
/worktree-list cleanup

# Limpiar referencias huérfanas
/worktree-list prune
```

**[Documentación completa →](./worktree-list.md)**

---

## Documentación Completa

### Por Nivel

| Documento | Audiencia | Tiempo Lectura |
|-----------|-----------|----------------|
| [`START_HERE.md`](./START_HERE.md) | **Principiantes** | 5 min |
| [`CHEATSHEET.md`](./CHEATSHEET.md) | **Referencia rápida** | 2 min |
| `README.md` (este archivo) | **Overview general** | 10 min |

### Por Comando

| Comando | Documentación | Nivel |
|---------|---------------|-------|
| `/worktree-start` | [`worktree-start.md`](./worktree-start.md) | 📘 Detallado |
| `/worktree-compare` | [`worktree-compare.md`](./worktree-compare.md) | 📘 Detallado |
| `/worktree-merge` | [`worktree-merge.md`](./worktree-merge.md) | 📘 Detallado |
| `/worktree-list` | [`worktree-list.md`](./worktree-list.md) | 📘 Detallado |

---

## Workflows

### Workflow 1: Feature Normal

```bash
# 1. Crear worktree
/worktree-start rails "Add two-factor authentication"
cd ../feat/two-factor-auth

# 2. Trabajar
# ... código, commits ...

# 3. Revisar
/worktree-compare main
bin/rails test

# 4. Merge
/worktree-merge main
```

**Tiempo típico:** 1-3 días  
**Complejidad:** Normal

---

### Workflow 2: Hotfix Urgente

```bash
# Mientras trabajas en feature (Terminal 1)
cd ../feat/big-feature

# Hotfix (Terminal 2 - nuevo)
cd /path/to/project
/worktree-start rails "Hotfix: Critical login bug"
cd ../hotfix/critical-login-bug
# ... fix rápido ...
/worktree-merge main

# Terminal 1: Sigues trabajando sin interrupciones
```

**Tiempo típico:** 30 min - 2 horas  
**Complejidad:** Alta urgencia, baja complejidad

---

### Workflow 3: Desarrollo Paralelo

```bash
# Terminal 1: Feature A (grande, toma días)
/worktree-start rails "Complete dashboard redesign"
cd ../feat/dashboard-redesign

# Terminal 2: Feature B (pequeña, toma horas)
/worktree-start rails "Add PDF export button"
cd ../feat/pdf-export-button

# Terminal 2: Terminas B primero
/worktree-merge main

# Terminal 1: Continúas con A
# Cuando termines:
/worktree-merge main
```

**Tiempo típico:** Variable  
**Complejidad:** Alta (gestión múltiple)

---

### Workflow 4: Experimentación

```bash
# Probar idea nueva sin commitment
/worktree-start rails "Experiment: React components instead of Hotwire"
cd ../feat/experiment-react-components

# Experimentar...
# ... no funciona bien ...

# Abandonar sin consecuencias
cd /path/to/project
rm -rf ../feat/experiment-react-components
/worktree-list prune

# Proyecto principal no afectado
```

**Tiempo típico:** Variable (abandono OK)  
**Complejidad:** Baja (safe to fail)

---

### Workflow 5: Code Review

```bash
# Colega pide review de su rama
/worktree-start rails colleague-feature-branch
cd ../colleague-feature-branch

# Review local
# ... leer código, correr tests ...

# No merge, solo review
cd /path/to/project
rm -rf ../colleague-feature-branch
/worktree-list prune
```

**Tiempo típico:** 30 min - 1 hora  
**Complejidad:** Baja

---

## Best Practices

### 1. Usa Smart Mode Siempre

**❌ Evita:**
```bash
/worktree-start rails user-auth
```

**✅ Prefiere:**
```bash
/worktree-start rails "Add JWT authentication with refresh token support"
```

**Por qué:** Claude genera mejor branch name, crea guía útil, sugiere files.

---

### 2. Compara SIEMPRE Antes de Merge

**❌ Peligroso:**
```bash
/worktree-merge main  # Sin revisar
```

**✅ Seguro:**
```bash
/worktree-compare main  # Review cuidadoso
bin/rails test          # Tests pasan
/worktree-merge main    # Entonces merge
```

---

### 3. Features Cortas (<3 días)

**❌ Branch larga:**
- 2 semanas de development
- Muchos conflictos potenciales
- Review difícil

**✅ Branch corta:**
- 1-3 días de development
- Merge frecuente
- Conflictos mínimos
- Review fácil

---

### 4. Terminal/IDE Separado por Worktree

**❌ Confuso:**
```bash
cd ../worktree-a
# trabajo...
cd ../worktree-b
# ¿dónde estoy?
```

**✅ Claro:**
- Terminal 1: worktree-a
- Terminal 2: worktree-b
- Cada uno en su espacio

---

### 5. Cleanup Regular

```bash
# Todos los viernes
/worktree-list cleanup
/worktree-list prune
```

**Mantiene workspace limpio y organizado.**

---

### 6. Tests Antes de Merge

```bash
# Rails
bin/rails test
bundle exec rubocop

# WordPress
npm run build
vendor/bin/phpunit  # si configurado
```

**No hagas merge si tests fallan.**

---

### 7. Commit Messages Claros

**❌ Malos:**
```
git commit -m "changes"
git commit -m "fix"
git commit -m "WIP"
```

**✅ Buenos:**
```
git commit -m "[feat] Add JWT token generation"
git commit -m "[fix] Correct token expiration logic"
git commit -m "[test] Add integration tests for auth flow"
```

---

## FAQ

### General

**Q: ¿Cuántos worktrees puedo tener?**  
A: Técnicamente ilimitados, pero recomendado 2-3 máximo para no confundirte.

**Q: ¿Los worktrees comparten el mismo .git?**  
A: Sí, todos apuntan al mismo repositorio con diferentes checkouts.

**Q: ¿Afecta mi proyecto principal?**  
A: No, cada worktree es completamente independiente.

**Q: ¿Puedo hacer push desde un worktree?**  
A: Sí, funciona exactamente igual que una rama normal.

**Q: ¿Qué pasa si borro un worktree manualmente?**  
A: Git mantiene referencias. Usa `/worktree-list prune` para limpiar.

---

### Smart Mode vs Manual

**Q: ¿Cuándo usar smart mode?**  
A: Siempre que la feature tome >1 hora. Claude genera context útil.

**Q: ¿Cuándo usar manual mode?**  
A: Fixes rápidos (<30 min) donde no necesitas AI assistance.

**Q: ¿Claude siempre genera buen nombre?**  
A: 90% del tiempo sí. Si no te gusta, puedes editar el branch name después.

---

### Problemas Comunes

**Q: "Branch already exists" error?**  
A: Ya tienes un worktree con ese nombre. Usa `/worktree-list` para verificar.

**Q: "Uncommitted changes" al hacer merge?**  
A: Commitea tus cambios primero: `git add . && git commit -m "msg"`

**Q: ¿Cómo resolver merge conflicts?**  
A: Manualmente: abrir archivos, resolver <<<<<<, git add, git commit.

**Q: ¿Worktree no se elimina?**  
A: Cierra todos los terminales/IDEs usando ese directorio primero.

---

### Performance

**Q: ¿Los worktrees consumen mucho espacio?**  
A: No, comparten el .git directory. Solo se duplican archivos de working tree.

**Q: ¿Es más lento que branches normales?**  
A: No, performance es idéntica.

---

### Equipos

**Q: ¿Funciona con equipos?**  
A: Sí, cada desarrollador gestiona sus propios worktrees localmente.

**Q: ¿Debo hacer commit de .claude/?**  
A: No, el install.sh automáticamente lo agrega a .gitignore.

**Q: ¿Puedo usar con Pull Requests?**  
A: Sí, push tu branch normalmente y crea PR. Luego `/worktree-list cleanup`.

---

## Troubleshooting

### Problema: Commands no aparecen en Claude Code

**Solución:**
```bash
# Verificar instalación
ls .claude/commands/

# Reinstalar
./install.sh
```

---

### Problema: "Not in a worktree" error

**Causa:** Ejecutando comando desde repo principal

**Solución:**
```bash
cd ../your-feature-branch
/worktree-compare main
```

---

### Problema: Merge conflicts

**Causa:** Archivos modificados en ambas ramas

**Solución:**
```bash
# Git pausa el merge
# 1. Abrir archivos con <<<<<<<
# 2. Resolver manualmente
# 3. git add <resolved-files>
# 4. git commit
# 5. git push origin main
# 6. Cleanup manual del worktree
```

---

### Problema: Worktree directory no se borra

**Causa:** IDE/terminal usando el directorio

**Solución:**
```bash
# Cerrar todas las ventanas/terminales
# Luego:
git worktree remove /path/to/worktree --force

# O manualmente:
rm -rf /path/to/worktree
/worktree-list prune
```

---

### Problema: Branch no se borra

**Causa:** Branch tiene commits no mergeados

**Solución:**
```bash
# Ver qué commits no están mergeados
git log main..your-branch

# Force delete si estás seguro
git branch -D your-branch
```

---

### Problema: "Permission denied" en install.sh

**Solución:**
```bash
chmod +x install.sh
./install.sh
```

---

## Stack-Specific Notes

### Rails Projects

**Convenciones de nombres:**
- `feat/*` - Nueva feature
- `fix/*` - Bug fix
- `refactor/*` - Refactorización
- `test/*` - Tests
- `chore/*` - Maintenance

**Pre-merge checklist:**
- [ ] `bin/rails test` → Pass
- [ ] `bundle exec rubocop` → No offenses
- [ ] Migrations incluidas y reversibles
- [ ] Schema.rb actualizado
- [ ] No `binding.pry` en código

**Directorios comunes:**
- `app/models/`
- `app/controllers/`
- `db/migrate/`
- `spec/` o `test/`
- `config/routes.rb`

---

### WordPress Projects

**Convenciones de nombres:**
- `feature/*` - Nueva feature
- `bugfix/*` - Bug fix
- `enhancement/*` - Mejora
- `hotfix/*` - Critical fix

**Pre-merge checklist:**
- [ ] `npm run build` → Compiled
- [ ] No `var_dump()` en código
- [ ] Assets compilados
- [ ] Composer.lock actualizado si Composer.json cambió
- [ ] Plugin/theme version bumped (si aplica)

**Directorios comunes (WordPlate):**
- `app/themes/`
- `app/plugins/`
- `resources/` (Sage)
- `config/`

---

## Advanced Topics

### Multiple Repositories

Si trabajas con múltiples proyectos:

```bash
# Proyecto A
cd ~/projects/project-a
./install.sh

# Proyecto B
cd ~/projects/project-b
./install.sh

# Cada uno tiene sus propios worktrees
# Totalmente independientes
```

---

### Custom Configurations

Editar comandos:

```bash
# Comandos están en:
.claude/commands/worktree-*.md

# Puedes personalizar:
# - Branch naming conventions
# - Pre-merge checks
# - Output format
# - Etc.
```

---

### Integration with CI/CD

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: bin/rails test
      
      # Worktrees son transparentes para CI
      # No requieren configuración especial
```

---

## Contributing

### Reportar Bugs

Abre un issue con:
- Descripción del problema
- Pasos para reproducir
- Output de error completo
- Versión de Git: `git --version`
- Sistema operativo

---

### Sugerir Features

Abre un issue con:
- Descripción de la feature
- Caso de uso
- Ejemplo de cómo funcionaría

---

### Pull Requests

1. Fork del repositorio
2. Crear feature branch (usa estos worktree commands! 😉)
3. Hacer cambios
4. Tests pasan
5. Submit PR

---

## Roadmap

### v1.1 (Próximo)

- [ ] Support para más project types (Python, Node.js)
- [ ] Interactive mode para worktree-start
- [ ] Visual diff tool integration
- [ ] Better conflict resolution workflow

### v1.2 (Futuro)

- [ ] Web UI para gestión de worktrees
- [ ] Metrics y analytics
- [ ] Team collaboration features
- [ ] Integration con popular project management tools

---

## License

MIT License - Ver [`LICENSE`](./LICENSE) para detalles.

---

## Acknowledgments

- Creado para Claude Code por Alex
- Inspirado por la frustración con stash/switch workflows
- Gracias a la comunidad Git por el concepto de worktrees

---

## Support

**¿Necesitas ayuda?**
1. Lee [`START_HERE.md`](./START_HERE.md) primero
2. Consulta [`CHEATSHEET.md`](./CHEATSHEET.md) para referencia rápida
3. Revisa este README
4. Busca en sección [FAQ](#faq) y [Troubleshooting](#troubleshooting)
5. Abre un issue si aún tienes problemas

---

## Final Notes

**Este sistema está diseñado para hacer tu vida más fácil, no más complicada.**

Si encuentras que los comandos son confusos o no funcionan como esperas, es un bug - por favor reporta.

El objetivo es que uses worktrees sin pensar en la complejidad subyacente. Si tienes que leer documentación de git para entender qué hace un comando, hemos fallado.

**Happy parallel development! 🚀**

---

*Última actualización: Noviembre 2025*  
*Versión: 1.0.0*

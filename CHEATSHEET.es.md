# Git Worktrees Cheatsheet

Referencia rápida para comandos de worktrees con Claude Code.

---

## 🚀 Quick Start

```bash
# Instalar comandos
./install.sh

# Crear worktree (smart mode - RECOMENDADO)
/worktree-start rails "Add JWT authentication with refresh tokens"

# Comparar antes de merge
/worktree-compare main

# Merge y cleanup
/worktree-merge main
```

---

## 📝 Slash Commands (Claude Code)

| Comando | Descripción | Ejemplo |
|---------|-------------|---------|
| `/worktree-start <tipo> "descripción"` | Crear worktree (smart) | `/worktree-start rails "Add JWT auth"` |
| `/worktree-start <tipo> nombre` | Crear worktree (manual) | `/worktree-start rails user-auth` |
| `/worktree-compare [rama]` | Comparar cambios | `/worktree-compare main` |
| `/worktree-merge [rama]` | Merge y cleanup | `/worktree-merge main` |
| `/worktree-list` | Listar worktrees | `/worktree-list` |
| `/worktree-list cleanup` | Limpiar merged | `/worktree-list cleanup` |
| `/worktree-list prune` | Limpiar stale | `/worktree-list prune` |

**💡 Pro Tip:** Usa smart mode (con descripción) - Claude genera el nombre automáticamente

---

## 🔄 Flujo de Trabajo Básico

```bash
# 1️⃣ CREAR - Smart mode con descripción detallada
/worktree-start rails "Add two-factor authentication with SMS and email support"

# 2️⃣ TRABAJAR - Navegar y codear
cd ../feat/two-factor-auth-sms-email
# ... código, commits ...

# 3️⃣ COMPARAR - Revisar antes de merge
/worktree-compare main

# 4️⃣ TESTEAR - Validar que funciona
bin/rails test              # Rails
vendor/bin/phpunit          # WordPress

# 5️⃣ MERGE - Integrar y limpiar
/worktree-merge main
```

---

## 🎯 Comandos Esenciales de Git

### Dentro del Worktree

```bash
# Ver estado
git status

# Commit cambios
git add .
git commit -m "[feat] Description"

# Push to remote
git push origin branch-name

# Ver diff de cambios actuales
git diff

# Ver log de commits
git log --oneline

# Stash temporal (si necesitas)
git stash
git stash pop
```

### Desde Repositorio Principal

```bash
# Ver todos los worktrees
git worktree list

# Eliminar worktree específico
git worktree remove /path/to/worktree

# Limpiar referencias stale
git worktree prune

# Ver branches mergeadas
git branch --merged main
```

---

## 📊 Comparación: Smart vs Manual Mode

| Aspecto | Smart Mode | Manual Mode |
|---------|-----------|-------------|
| **Comando** | `/worktree-start rails "Add JWT auth"` | `/worktree-start rails jwt-auth` |
| **Nombre rama** | Auto-generado por Claude | Usas el que especificas |
| **FEATURE.md** | ✅ Creado con context | ❌ No se crea |
| **Sugerencias** | ✅ Files a revisar | ❌ Sin sugerencias |
| **Checklist** | ✅ TODO generado | ❌ Sin checklist |
| **Velocidad** | Más lento (~5s) | Más rápido (~1s) |
| **Uso recomendado** | Features complejas | Fixes rápidos |

**💡 Regla:** Si el proyecto toma >1 hora, usa smart mode.

---

## ⚡ Atajos y Tips

### Navegación Rápida

```bash
# Alias útiles (agregar a .bashrc/.zshrc)
alias wl='/worktree-list'
alias ws='/worktree-start'
alias wc='/worktree-compare'
alias wm='/worktree-merge'

# Navegación rápida
cd ..     # Subir al directorio padre
cd -      # Volver al directorio anterior
```

### Múltiples Terminals/IDEs

```bash
# Terminal 1: Main work
cd /path/to/project

# Terminal 2: Feature A
cd /path/to/project
/worktree-start rails "Feature A"
cd ../feat/feature-a

# Terminal 3: Feature B
cd /path/to/project
/worktree-start rails "Feature B"
cd ../feat/feature-b

# Cada terminal trabaja independientemente
```

### Cleanup Rápido Semanal

```bash
# Todos los viernes
/worktree-list cleanup && /worktree-list prune
```

---

## 🔍 Troubleshooting Rápido

| Error | Causa | Solución Rápida |
|-------|-------|-----------------|
| "Branch already exists" | Ya existe worktree | `/worktree-list` → verificar |
| "Uncommitted changes" | Cambios sin commit | `git add . && git commit -m "msg"` |
| "Not in a worktree" | Comando en repo principal | `cd ../feature-branch` |
| "Merge conflict" | Archivos en conflicto | Resolver manualmente |
| Worktree no se elimina | Directorio en uso | Cerrar IDE/terminal |

---

## 📐 Convenciones de Nombres

### Rails Projects

| Prefix | Uso | Ejemplo |
|--------|-----|---------|
| `feat/` | Nueva feature | `feat/jwt-authentication` |
| `fix/` | Bug fix | `fix/login-validation` |
| `refactor/` | Refactorización | `refactor/user-model` |
| `test/` | Tests | `test/auth-integration` |
| `chore/` | Maintenance | `chore/update-deps` |

### WordPress Projects

| Prefix | Uso | Ejemplo |
|--------|-----|---------|
| `feature/` | Nueva feature | `feature/custom-widget` |
| `bugfix/` | Bug fix | `bugfix/payment-flow` |
| `enhancement/` | Mejora | `enhancement/admin-ui` |
| `hotfix/` | Critical fix | `hotfix/security-patch` |

---

## 📋 Pre-Merge Checklist

Antes de hacer `/worktree-merge`, verifica:

### Rails
- [ ] `bin/rails test` → ✅ Pass
- [ ] `bundle exec rubocop` → ✅ No offenses
- [ ] No `binding.pry` o `debugger` en código
- [ ] Migraciones incluidas y reversibles
- [ ] Schema.rb actualizado
- [ ] Routes OK
- [ ] No credenciales hardcoded

### WordPress
- [ ] `npm run build` → ✅ Compiled
- [ ] No `var_dump()` o `dd()` en código
- [ ] Assets compilados en `public/`
- [ ] Composer dependencies OK
- [ ] Plugin/theme version bumped (si aplica)
- [ ] No API keys en código

---

## 🎓 Workflows Comunes

### Workflow 1: Feature Normal

```bash
/worktree-start rails "Add feature X"
cd ../feat/feature-x
# ... work ...
git add . && git commit -m "[feat] Add X"
/worktree-compare main
/worktree-merge main
```

### Workflow 2: Hotfix Urgente

```bash
# Mientras trabajas en feature
/worktree-start rails "Hotfix: Critical bug"
cd ../hotfix/critical-bug
# ... fix ...
git add . && git commit -m "[fix] Critical bug"
/worktree-merge main
# Volver a feature sin interrupciones
```

### Workflow 3: Experimentación

```bash
/worktree-start rails "Experiment with X"
cd ../feat/experiment-x
# ... try things ...
# ¿No funciona? No problem
cd ..
rm -rf feat/experiment-x
/worktree-list prune
```

### Workflow 4: Code Review

```bash
/worktree-start rails colleague-branch
cd ../colleague-branch
# ... review code, run tests ...
# No merge, solo review
cd ..
rm -rf colleague-branch
/worktree-list prune
```

---

## 💾 Comandos Git Útiles

### Ver Cambios

```bash
# Diff de working directory
git diff

# Diff staged
git diff --staged

# Diff con otra rama
git diff main..HEAD

# Ver archivo específico
git diff main -- path/to/file

# Stats de cambios
git diff --stat main..HEAD
```

### Logs y Historia

```bash
# Log compacto
git log --oneline -10

# Log con graph
git log --oneline --graph --all

# Commits no en main
git log main..HEAD --oneline

# Ver commit específico
git show <commit-hash>
```

### Branches

```bash
# Listar branches
git branch

# Ver mergeadas
git branch --merged main

# Ver no mergeadas
git branch --no-merged main

# Borrar branch local
git branch -d branch-name
git branch -D branch-name  # force

# Borrar branch remote
git push origin --delete branch-name
```

---

## 🔧 Configuración Recomendada

### Git Config Global

```bash
# Better log alias
git config --global alias.lg "log --oneline --graph --all --decorate"

# Better status alias
git config --global alias.st "status -sb"

# Better diff alias
git config --global alias.df "diff --color --stat"

# Auto-prune on fetch
git config --global fetch.prune true

# Default push behavior
git config --global push.default current
```

### Install Delta (Better Diffs)

```bash
# macOS
brew install git-delta

# Linux
cargo install git-delta

# Auto-usado por /worktree-compare
```

---

## 📚 Comandos por Frecuencia de Uso

### Diarios (80%)

```bash
/worktree-start rails "Feature description"
cd ../feature-branch
git add . && git commit -m "msg"
/worktree-compare main
/worktree-merge main
```

### Semanales (15%)

```bash
/worktree-list cleanup
/worktree-list prune
/worktree-list  # Ver estado
```

### Ocasionales (5%)

```bash
git worktree remove /path/to/worktree
git branch -D branch-name
git push origin --delete branch-name
```

---

## 🚫 Anti-Patterns (Evita Estos)

### ❌ NO hacer

```bash
# Crear worktree sin descripción meaningful
/worktree-start rails "test"
/worktree-start rails "changes"
/worktree-start rails "wip"

# Merge sin comparar primero
/worktree-merge main  # Sin /worktree-compare antes

# Tener 10+ worktrees abiertos
# CONFUSO!

# Navegar entre worktrees en mismo terminal
cd ../worktree1
cd ../worktree2  # Confusión garantizada

# Hacer rm -rf sin git worktree remove
rm -rf ../feature-branch
# Deja referencias huérfanas
```

### ✅ SÍ hacer

```bash
# Descripción específica en smart mode
/worktree-start rails "Add OAuth2 with Google and GitHub providers"

# Siempre comparar antes de merge
/worktree-compare main
/worktree-merge main

# Máximo 2-3 worktrees activos
# Manejable

# Usar terminal/IDE separado por worktree
# Cada uno en su espacio

# Usar comandos propios para cleanup
/worktree-merge main  # Auto-cleanup
```

---

## 🎯 KPIs de Buen Uso

**Indicadores de que lo estás usando bien:**

- ✅ Features se merges en <3 días
- ✅ `/worktree-list` muestra <4 worktrees
- ✅ Siempre usas `/worktree-compare` antes de merge
- ✅ Tests pasan antes de cada merge
- ✅ Cleanup semanal mantiene workspace limpio

**Señales de alerta:**

- ⚠️ 10+ worktrees abiertos
- ⚠️ Branches con 2+ semanas sin merge
- ⚠️ Muchos "WIP" commits
- ⚠️ Nunca usas `/worktree-compare`
- ⚠️ Siempre tienes merge conflicts

---

## 📖 Referencias Rápidas

### Documentación Completa

- [`START_HERE.md`](./START_HERE.md) - Tutorial paso a paso
- [`README.md`](./README.md) - Guía completa
- [`worktree-start.md`](./worktree-start.md) - Detalles de creación
- [`worktree-compare.md`](./worktree-compare.md) - Detalles de comparación
- [`worktree-merge.md`](./worktree-merge.md) - Detalles de merge
- [`worktree-list.md`](./worktree-list.md) - Gestión y cleanup

### Enlaces Útiles

- [Git Worktree Docs](https://git-scm.com/docs/git-worktree)
- [Claude Code Docs](https://docs.claude.com/en/docs/claude-code)
- [Git Best Practices](https://git-scm.com/book/en/v2)

---

## 🎓 Para Memorizar

**Los 3 comandos que usarás el 90% del tiempo:**

```bash
1. /worktree-start rails "Feature description"
2. /worktree-compare main
3. /worktree-merge main
```

**Regla de oro:**

> Siempre compara antes de hacer merge.
> Features cortas (<3 días).
> Cleanup regular.

---

**Imprime esto y pégalo en tu monitor. 📌**

**¿Necesitas más detalles?** → [`START_HERE.md`](./START_HERE.md)

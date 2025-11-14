# 🚀 START HERE: Git Worktrees con Claude Code

**Versión 1.1.0** - ¡Ahora con soporte para 7 stacks, modo verbose y configuración local!

Esta guía te ayudará a empezar en **2 minutos** con el sistema de worktrees.

## ⚡ Quick Start (60 segundos)

```bash
# 1. Instalar (solo una vez)
cd /path/to/tu/proyecto
./install.sh

# 2. Crear tu primer worktree (SMART MODE)
/worktree-start rails "Add user authentication with JWT"

# 3. Trabajar en la feature
cd ../feat/user-authentication-jwt
# ... código, commits ...

# 4. Comparar antes de merge
/worktree-compare main

# 5. Merge cuando estés listo
/worktree-merge main
```

¡Listo! Ya puedes trabajar en múltiples features simultáneamente.

---

## 🎯 ¿Qué Problema Resuelve?

**Antes (sin worktrees):**
```bash
# Estás trabajando en feature A
git checkout -b feature-a
# ... haciendo cambios ...

# OH NO! Bug urgente en producción
# Tienes que:
git stash          # Guardar cambios
git checkout main  # Cambiar rama
git checkout -b hotfix
# ... arreglar bug ...
git checkout feature-a
git stash pop      # Recuperar cambios
# Oops, conflictos con el stash...
```

**Ahora (con worktrees):**
```bash
# Terminal 1: Trabajando en feature A
/worktree-start rails "Feature A"
cd ../feat/feature-a
# ... haciendo cambios tranquilamente ...

# Terminal 2: Bug urgente
/worktree-start rails "Hotfix urgent bug"
cd ../hotfix/urgent-bug
# ... arreglas el bug ...
/worktree-merge main

# Terminal 1: Sigues trabajando sin interrupciones
# No hay stashes, no hay conflictos, no hay estrés
```

---

## 📚 Los 4 Comandos Esenciales

### 1. `/worktree-start` - Crear worktree nuevo

**Smart Mode (RECOMENDADO):**
```bash
/worktree-start rails "Add JWT authentication with refresh tokens"
```
- Claude analiza tu descripción
- Genera nombre de rama apropiado
- Crea `FEATURE.md` con contexto y checklist
- Te dice por dónde empezar

**Manual Mode:**
```bash
/worktree-start rails user-authentication
```
- Usa el nombre que especifiques directamente
- Más rápido pero sin AI assistant

### 2. `/worktree-compare` - Ver cambios antes de merge

```bash
/worktree-compare main
```

**Te muestra:**
- ✅ Resumen de archivos cambiados
- ✅ Lista de commits
- ✅ Detección de conflictos potenciales
- ✅ Diff completo para review

**Regla de oro:** SIEMPRE compara antes de hacer merge.

### 3. `/worktree-merge` - Hacer merge y limpiar

```bash
/worktree-merge main
```

**Hace todo automáticamente:**
1. Valida que no hay cambios sin commitear
2. Hace merge a la rama principal
3. Push a remote
4. Elimina el worktree
5. Borra la rama
6. Te deja en la rama principal, listo para lo siguiente

### 4. `/worktree-list` - Ver y limpiar worktrees

```bash
/worktree-list              # Ver todos los worktrees activos
/worktree-list cleanup      # Limpiar worktrees ya mergeados
/worktree-list prune        # Limpiar referencias obsoletas
```

---

## 🎓 Tutorial Paso a Paso

### Ejemplo Completo: Agregar Autenticación JWT

#### Paso 1: Crear worktree

```bash
# Desde tu proyecto principal
pwd  # /Users/you/myproject

# Smart mode - Claude ayuda
/worktree-start rails "Add JWT authentication with refresh tokens and remember me"
```

**Claude genera:**
- Nombre de rama: `feat/jwt-auth-refresh-tokens`
- `FEATURE.md` con checklist detallada
- Sugerencias de archivos a revisar primero

#### Paso 2: Trabajar en la feature

```bash
# Navegar al nuevo worktree
cd ../feat/jwt-auth-refresh-tokens

# Revisar guía generada
cat FEATURE.md

# Empezar a codear
# ... crear modelos, controllers, tests ...

# Commits frecuentes
git add .
git commit -m "[feat] Add JWT token model"
git commit -m "[feat] Add authentication controller"
git commit -m "[test] Add JWT auth tests"
```

#### Paso 3: Revisar cambios

```bash
# Antes de merge, siempre comparar
/worktree-compare main
```

**Revisa cuidadosamente:**
- ¿Los cambios tienen sentido?
- ¿Hay archivos inesperados?
- ¿Conflictos potenciales?
- ¿Tests pasan?
- ¿Código limpio sin debugging statements?

#### Paso 4: Correr tests

```bash
# Rails
bin/rails test

# PHP
vendor/bin/phpunit  # si está configurado
```

**No hagas merge si los tests fallan.**

#### Paso 5: Merge

```bash
# Si todo está bien
/worktree-merge main

# Confirma cuando se te pregunte
# El comando hace todo automáticamente
```

#### Paso 6: Verificar

```bash
# Deberías estar de vuelta en main
pwd  # /Users/you/myproject
git branch --show-current  # main

# Ver que todo está mergeado
git log --oneline -5

# Worktree ya no existe
ls ../  # feat/jwt-auth-refresh-tokens ya no está
```

---

## 💡 Casos de Uso Comunes

### Caso 1: Trabajar en Múltiples Features Simultáneamente

```bash
# Terminal 1: Feature grande (toma días)
/worktree-start rails "Redesign entire dashboard with Tailwind"
cd ../feat/dashboard-redesign
# ... trabajo en progreso ...

# Terminal 2: Feature rápida (toma horas)
/worktree-start rails "Add export to PDF button"
cd ../feat/pdf-export
# ... terminas rápido ...
/worktree-merge main

# Terminal 1: Sigues con dashboard sin interrupciones
# Cuando termines:
/worktree-merge main
```

### Caso 2: Bug Urgente Mientras Trabajas en Feature

```bash
# Estás en medio de una feature
cd ../feat/big-feature
# ... cambios sin commitear ...

# Bug urgente reportado
# No necesitas stash!

# Nuevo terminal/tab
cd /path/to/main/project
/worktree-start rails "Fix critical login bug"
cd ../hotfix/critical-login-bug
# ... arreglas el bug ...
/worktree-merge main

# Terminal original: Sigues donde estabas
# Sin stash, sin conflictos
```

### Caso 3: Experimentar Sin Miedo

```bash
# Quieres probar algo pero no estás seguro
/worktree-start rails "Experiment with new UI library"
cd ../feat/experiment-ui-library

# Pruebas, juegas, rompes cosas...
# No te gusta el resultado?

# Fácil: simplemente no hagas merge
cd /path/to/main/project
rm -rf ../feat/experiment-ui-library
/worktree-list prune

# Tu proyecto principal nunca fue afectado
```

### Caso 4: Code Review de Colega

```bash
# Tu colega te pide review de su rama
/worktree-start rails colleague-feature-branch

# Revisas el código localmente
cd ../colleague-feature-branch
# ... review, run tests, etc ...

# No necesitas hacer merge, solo review
cd /path/to/main/project
rm -rf ../colleague-feature-branch
/worktree-list prune
```

---

## ⚠️ Errores Comunes y Soluciones

### Error 1: "Branch already exists"

**Causa:** Ya tienes un worktree con ese nombre

**Solución:**
```bash
# Ver worktrees activos
/worktree-list

# Si ya está mergeado
/worktree-list cleanup

# Si quieres eliminar específicamente
git worktree remove /path/to/worktree
```

### Error 2: "You have uncommitted changes"

**Causa:** Intentas hacer merge con cambios sin commitear

**Solución:**
```bash
# Commitear cambios
git add .
git commit -m "Description of changes"

# O hacer stash si no estás listo
git stash

# Luego retry merge
```

### Error 3: "Merge conflict"

**Causa:** Alguien modificó los mismos archivos

**Solución:**
```bash
# El merge se detiene, muestra archivos en conflicto
# Resolver manualmente:
# 1. Abrir archivos marcados con <<<<<<<
# 2. Resolver conflictos
# 3. git add <resolved-files>
# 4. git commit
# 5. git push origin main
# 6. Cleanup manual del worktree
```

### Error 4: "Not in a worktree"

**Causa:** Intentas usar `/worktree-compare` o `/worktree-merge` desde el repo principal

**Solución:**
```bash
# Navegar al worktree primero
cd ../your-feature-branch
/worktree-compare main
```

---

## 📖 Diferencias por Stack

### Rails Projects

**Naming convention:**
- `feat/*` - Nueva funcionalidad
- `fix/*` - Bug fix
- `refactor/*` - Refactorización
- `test/*` - Tests
- `chore/*` - Maintenance

**Antes de merge, verificar:**
```bash
bin/rails test          # Tests pasan
bundle exec rubocop     # Linting OK
```

**Archivos típicos modificados:**
- `app/models/*`
- `app/controllers/*`
- `db/migrate/*`
- `config/routes.rb`
- `spec/` o `test/`

### Proyectos PHP

**Naming convention:**
- `feat/*` - Nueva funcionalidad (default)
- `fix/*` - Bug fix
- `refactor/*` - Refactorización
- `hotfix/*` - Fix crítico

> **Nota:** Los proyectos PHP pueden personalizarse por framework. Consulta `.worktree-config.examples.json` para configuraciones de WordPress, Laravel, Symfony.

**Antes de merge, verificar:**
```bash
composer install        # Dependencies OK
vendor/bin/phpunit      # Tests (o comando de test del framework)
npm run build           # Assets compilados (si aplica)
```

**Archivos típicos modificados:**
- `src/` o `app/*` - Código de aplicación
- `tests/*` - Tests
- `composer.json` - Dependencias
- Directorios específicos del framework

---

## 🔥 Tips Pro

### Tip 1: Usa Smart Mode Siempre

```bash
# ❌ Manual mode - sin ayuda
/worktree-start rails user-auth

# ✅ Smart mode - Claude te ayuda
/worktree-start rails "Add OAuth2 authentication with Google and GitHub"
```

**Por qué:** Claude genera nombre mejor, crea checklist, sugiere archivos.

### Tip 2: Abre IDE/Terminal Separado Por Worktree

```bash
# NO hagas esto:
cd ../worktree1
# trabajo...
cd ../worktree2
# trabajo...
# CONFUSO!

# SÍ haz esto:
# Terminal/IDE Window 1: worktree1
# Terminal/IDE Window 2: worktree2
# Cada uno en su propio espacio
```

### Tip 3: Compara SIEMPRE Antes de Merge

```bash
# Flujo correcto:
/worktree-compare main  # Revisar cambios
# ¿Todo bien?
/worktree-merge main

# NO hagas merge sin comparar primero
```

### Tip 4: Limpieza Regular

```bash
# Cada viernes:
/worktree-list cleanup
/worktree-list prune

# Workspace limpio para la próxima semana
```

### Tip 5: Features Cortas

**Regla de oro:** Merge en 1-3 días máximo

- ✅ Features pequeñas: Menos conflictos
- ✅ Review más fácil
- ✅ Integración continua
- ❌ Branches largas: Más conflictos, difícil review

---

## 🎯 Checklist Before Your First Worktree

Antes de usar worktrees por primera vez:

- [ ] Instalaste los comandos: `./install.sh`
- [ ] Estás en el directorio del proyecto principal
- [ ] Working directory está limpio o tiene cambios stashed
- [ ] Conoces el nombre de tu rama principal (`main` o `master`)
- [ ] Tienes una feature específica en mente para trabajar

**Listo?** Ejecuta:

```bash
/worktree-start <stack> "Tu descripción de feature"
# Ejemplo: /worktree-start rails "Add user authentication"
# Ejemplo: /worktree-start php "Add contact form"
```

---

## ❓ FAQ Rápido

**Q: ¿Puedo tener 10 worktrees abiertos?**
A: Técnicamente sí, pero no es recomendable. 2-3 máximo para no confundirte.

**Q: ¿Los worktrees comparten el mismo .git?**
A: Sí, todos apuntan al mismo repositorio pero con diferentes checkouts.

**Q: ¿Puedo hacer push desde un worktree?**
A: Sí, funciona exactamente igual que en una rama normal.

**Q: ¿Qué pasa si elimino un worktree manualmente?**
A: Git mantiene referencias. Usa `/worktree-list prune` para limpiarlas.

**Q: ¿Puedo usar worktrees con branches remotos?**
A: Sí, puedes crear worktree de un branch remoto.

**Q: ¿Y si dos personas trabajan en el mismo branch?**
A: Igual que branches normales: coordinación y pull/push regular.

---

## 🚀 Próximos Pasos

**Ya leíste esto?** Perfecto. Ahora:

1. **Práctica:** Crea tu primer worktree con una feature real
2. **Consulta:** Lee [`CHEATSHEET.md`](CHEATSHEET.md) para referencia rápida
3. **Profundiza:** Revisa [`README.md`](README.md) para detalles avanzados

**Documentación completa de cada comando:**
- [`worktree-start.md`](../worktree-start.md)
- [`worktree-compare.md`](../worktree-compare.md)
- [`worktree-merge.md`](../worktree-merge.md)
- [`worktree-list.md`](../worktree-list.md)

---

**¿Dudas? ¿Problemas?** Abre el comando relevante arriba y busca la sección "Troubleshooting".

**¡Feliz parallel development! 🚀**

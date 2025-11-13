# Checklist de Verificación para Slash Commands

## ⚠️ IMPORTANTE: Probar Antes de Publicar

Estos slash commands necesitan verificación manual en Claude Code antes del lanzamiento en GitHub.

## Procedimiento de Prueba

### 1. Configurar Entorno de Prueba

```bash
# Crear un repositorio git de prueba
cd /tmp
mkdir worktree-test-repo
cd worktree-test-repo
git init
echo "# Test" > README.md
git add .
git commit -m "Initial commit"
```

### 2. Instalar Comandos en Repo de Prueba

```bash
# Copiar comandos al repo de prueba
mkdir -p .claude/commands
cp /Users/alex/Desktop/dev_apps/worktree-claude-code-commands/worktree-*.md .claude/commands/
```

### 3. Probar Cada Comando

#### Probar /worktree-start

**Comportamiento esperado:**
- Claude Code debe parsear el front matter YAML
- Ejecutar comandos bash secuencialmente
- Generar nombre de rama (en smart mode)
- Crear directorio de worktree
- Crear FEATURE.md con contenido generado por AI

**Casos de prueba:**
```bash
# Smart mode - Rails
/worktree-start rails "Agregar sistema de autenticación de usuario"

# Manual mode - Rails
/worktree-start rails feat/user-auth

# Smart mode - WordPress
/worktree-start wp "Agregar formulario de contacto con validación"

# Manual mode - WordPress
/worktree-start wp feature/contact-form
```

**Verificación:**
- [ ] Rama creada con convención de nomenclatura correcta
- [ ] Directorio de worktree existe en `../[nombre-rama]`
- [ ] FEATURE.md generado (solo smart mode)
- [ ] Cambios actuales guardados en stash si existen
- [ ] Manejo de errores funciona (rama duplicada, entrada inválida)

#### Probar /worktree-list

**Comportamiento esperado:**
- Listar todos los worktrees activos
- Mostrar rama y ruta para cada uno
- Resaltar worktree actual

**Casos de prueba:**
```bash
/worktree-list
```

**Verificación:**
- [ ] Muestra todos los worktrees correctamente
- [ ] El formato es claro y legible
- [ ] El worktree actual está resaltado

#### Probar /worktree-compare

**Comportamiento esperado:**
- Mostrar estadísticas de cambios
- Listar commits
- Detectar conflictos potenciales
- Mostrar diff detallado

**Casos de prueba:**
```bash
# Cambiar a un worktree y hacer algunos cambios
cd ../feat/user-auth
echo "test" >> test.txt
git add .
git commit -m "Test commit"

# Volver a main y comparar
cd ../main
/worktree-compare feat/user-auth
```

**Verificación:**
- [ ] Muestra conteo de archivos y cambios de líneas
- [ ] Lista commits correctamente
- [ ] Detecta conflictos si existen
- [ ] Muestra diff (preferiblemente con Delta)

#### Probar /worktree-merge

**Comportamiento esperado:**
- Ejecutar comprobaciones previas al vuelo
- Merge con --no-ff
- Push a remote (si está configurado)
- Limpiar worktree y ramas
- Pedir confirmación antes de operaciones destructivas

**Casos de prueba:**
```bash
/worktree-merge feat/user-auth
```

**Verificación:**
- [ ] Pide confirmación antes de merge
- [ ] Crea commit de merge
- [ ] Intenta push a remote
- [ ] Elimina directorio de worktree
- [ ] Borra rama local
- [ ] Borra rama remota (si se hizo push)
- [ ] Regresa a rama main/master

## Problemas Comunes a Vigilar

### Problema 1: Ejecución de Bash
**Problema:** Claude Code podría no ejecutar bash directamente desde markdown
**Solución:** Los comandos podrían necesitar estar en formato de script ejecutable

### Problema 2: Prompts Interactivos
**Problema:** Comandos con `read -p` podrían no funcionar en Claude Code
**Solución:** Podría necesitar usar mecanismo de prompt nativo de Claude

### Problema 3: Sustitución de Variables
**Problema:** Variables bash en heredocs podrían no expandirse correctamente
**Solución:** Podría necesitar diferente entrecomillado o escapado

### Problema 4: Salida Multilínea
**Problema:** Salidas largas podrían truncarse
**Solución:** Podría necesitar paginación o vistas resumidas

### Problema 5: Directorio Actual
**Problema:** Comandos asumen ejecución desde raíz de repo
**Solución:** Podría necesitar agregar comandos `cd` o validación de ruta

## Resultados

Después de probar, documentar:

1. **Qué funciona:**
   - [ ] Comando 1: /worktree-start
   - [ ] Comando 2: /worktree-list
   - [ ] Comando 3: /worktree-compare
   - [ ] Comando 4: /worktree-merge

2. **Qué no funciona:**
   - [ ] Listar problemas aquí

3. **Correcciones requeridas:**
   - [ ] Documentar cambios necesarios

## Próximos Pasos

Basado en resultados:
- ✅ **Si todo funciona:** Proceder con preparación de GitHub
- ⚠️ **Si es parcial:** Corregir problemas y re-probar
- ❌ **Si nada funciona:** Refactorizar formato de comando

---

**Fecha probada:** _______________
**Versión de Claude Code:** _______________
**Probador:** _______________

# ✅ SOLUCIONADO: EXPORT_PRESETS.CFG SE BORRABA EN DEPLOY

## 🔍 Problema Identificado
El archivo `export_presets.cfg` se eliminaba durante el proceso de deploy debido a que `git rm -rf .` borraba todos los archivos de la rama gh-pages, causando que las exportaciones posteriores fallaran.

## 💡 Análisis de la Causa
1. **Deploy agresivo**: `git rm -rf .` eliminaba TODOS los archivos
2. **Archivo en .gitignore**: `export_presets.cfg` está ignorado por git
3. **Pérdida de configuración**: Cada deploy requería recrear manualmente el archivo
4. **Construcción fallida**: Sin el archivo, Godot no podía exportar para web

## ✅ Solución Implementada

### 1. **Deploy Inteligente**
```bash
# ANTES: Borrado agresivo
git rm -rf . 2>/dev/null || true

# DESPUÉS: Borrado selectivo solo de archivos web
rm -f *.html *.js *.wasm *.pck *.png *.icon.png *.apple-touch-icon.png
rm -f *.audio.*.js *.worklet.js 2>/dev/null || true
```

### 2. **Auto-creación en Build**
```bash
# Verificar que export_presets.cfg existe
if [ ! -f "export_presets.cfg" ]; then
    echo "⚠️  Creando export_presets.cfg..."
    cat > export_presets.cfg << 'EOF'
[preset.0]
name="Web"
platform="Web"
runnable=true
# ... configuración completa ...
EOF
fi
```

### 3. **Auto-creación en Deploy**
```bash
# Verificar que export_presets.cfg existe antes del deploy
if [ ! -f "export_presets.cfg" ]; then
    echo "⚠️  No se encuentra export_presets.cfg, creándolo..."
    # ... crear archivo con configuración completa ...
fi
```

## 🔧 Scripts Actualizados

### **build_web.sh**
- ✅ Verifica existencia de `export_presets.cfg`
- ✅ Crea automáticamente si no existe
- ✅ Continúa con la exportación sin interrupción

### **deploy_github_pages.sh**
- ✅ Borrado selectivo (solo archivos web)
- ✅ Preserva archivos de configuración
- ✅ Auto-creación de `export_presets.cfg` si falta
- ✅ Deploy sin pérdida de configuración

## 📋 Configuración de export_presets.cfg
```ini
[preset.0]
name="Web"
platform="Web"
runnable=true
dedicated_server=false
export_filter="all_resources"
export_path="build/web/index.html"
encrypt_pck=false

[preset.0.options]
variant/extensions_support=false
vram_texture_compression/for_desktop=true
vram_texture_compression/for_mobile=false
html/export_icon=true
html/canvas_resize_policy=2
html/focus_canvas_on_start=true
html/experimental_virtual_keyboard=false
progressive_web_app/enabled=false
```

## 🎯 Beneficios de la Solución

### ✅ **Robustez Mejorada:**
- **Auto-recuperación**: Scripts crean archivos faltantes automáticamente
- **Deploy seguro**: No se pierden configuraciones importantes
- **Construcción consistente**: Siempre tiene la configuración correcta

### ✅ **Workflow Simplificado:**
- **Un comando**: `./build_web.sh && ./deploy_github_pages.sh`
- **Sin intervención**: No requiere recrear archivos manualmente
- **Consistencia**: Misma configuración en cada build

### ✅ **Mantenimiento Reducido:**
- **Menos errores**: No más fallos por archivos faltantes
- **Menos pasos manuales**: Todo automatizado
- **Más confiable**: Sistema robusto contra pérdidas de archivos

## 🚀 Prueba del Sistema Corregido

### **Primera Construcción:**
```bash
$ ./build_web.sh
🎮 Construyendo proyecto MineRights para web...
⚠️  Creando export_presets.cfg...
✅ Exportación completada exitosamente
```

### **Deploy Exitoso:**
```bash
$ ./deploy_github_pages.sh
🚀 Desplegando MineRights a GitHub Pages...
🧹 Limpiando archivos web anteriores...
📂 Copiando archivos web...
✅ Despliegue completado!
```

### **Construcción Posterior:**
```bash
$ ./build_web.sh
🎮 Construyendo proyecto MineRights para web...
# (Ya existe export_presets.cfg, continúa directamente)
✅ Exportación completada exitosamente
```

## 📊 Estado Actual

- ✅ **Scripts inteligentes**: Auto-crean archivos faltantes
- ✅ **Deploy no destructivo**: Preserva configuraciones importantes
- ✅ **Workflow robusto**: Funciona consistentemente
- ✅ **Juego desplegado**: https://leito-monk.github.io/minerights/

**El problema del `export_presets.cfg` que se borraba está completamente solucionado. El sistema ahora es automático, robusto y no requiere intervención manual.** 🎮✨
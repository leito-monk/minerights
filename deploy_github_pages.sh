#!/bin/bash

# Script para desplegar el juego web a GitHub Pages

echo "🚀 Desplegando MineRights a GitHub Pages..."

# Verificar que existe el build web
if [ ! -d "build/web" ]; then
    echo "❌ No se encuentra el directorio build/web. Ejecuta ./build_web.sh primero."
    exit 1
fi

# Verificar que estamos en un repositorio git
if [ ! -d ".git" ]; then
    echo "❌ No se encuentra repositorio git."
    exit 1
fi

# Guardar el branch actual
CURRENT_BRANCH=$(git branch --show-current)
echo "📝 Branch actual: $CURRENT_BRANCH"

# Hacer commit de los cambios actuales si hay alguno
echo "💾 Guardando cambios locales..."
git add .
if ! git diff --cached --quiet; then
    git commit -m "Update: Nueva versión con menú principal y sistema de actividades"
fi

# Crear directorio temporal para los archivos web
echo "📦 Preparando archivos web..."
TEMP_DIR=$(mktemp -d)
cp build/web/* "$TEMP_DIR/"

# Cambiar a la rama gh-pages (crearla si no existe)
echo "🌿 Cambiando a rama gh-pages..."
if git show-ref --verify --quiet refs/heads/gh-pages; then
    git checkout gh-pages
else
    git checkout --orphan gh-pages
fi

# Limpiar solo archivos web anteriores en gh-pages
echo "🧹 Limpiando archivos web anteriores..."
# Solo eliminar archivos web específicos, no todos los archivos
rm -f *.html *.js *.wasm *.pck *.png *.icon.png *.apple-touch-icon.png
rm -f *.audio.*.js *.worklet.js 2>/dev/null || true

# Copiar archivos web desde el directorio temporal
echo "📂 Copiando archivos web..."
cp "$TEMP_DIR"/* .

# Limpiar directorio temporal
rm -rf "$TEMP_DIR"

# Agregar archivos y hacer commit
echo "📦 Creando commit para GitHub Pages..."
git add .
git commit -m "Deploy: Nueva versión completa con menú y actividades - $(date)"

# Push a GitHub Pages
echo "🚀 Subiendo a GitHub Pages..."
git push origin gh-pages

# Volver al branch original
echo "🔄 Volviendo a branch $CURRENT_BRANCH..."
git checkout $CURRENT_BRANCH

echo "✅ Despliegue completado!"
echo "🌐 Tu juego estará disponible en: https://leito-monk.github.io/minerights/"
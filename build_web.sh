#!/bin/bash

# Script para exportar el proyecto Godot para la web

echo "🎮 Construyendo proyecto MineRights para web..."

# Crear directorio de salida si no existe
mkdir -p build/web

# Exportar usando Godot en modo headless
/home/le/Descargas/Godot_v4.5.1-stable_linux.x86_64 --headless --export-release "Web" build/web/index.html

if [ $? -eq 0 ]; then
    echo "✅ Exportación completada exitosamente"
    echo "📁 Archivos generados en build/web/"
    ls -la build/web/
else
    echo "❌ Error durante la exportación"
    exit 1
fi
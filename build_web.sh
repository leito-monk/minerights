#!/bin/bash
# Script para exportar MineRights a la web

echo "🌐 Exportando MineRights para la web..."

# Crear directorio de build si no existe
mkdir -p build/web

# Exportar usando Godot
echo "📦 Iniciando exportación..."
/home/le/Descargas/Godot_v4.5.1-stable_linux.x86_64 --headless --export-release "Web" build/web/minerights.html

if [ $? -eq 0 ]; then
    echo "✅ Exportación completada exitosamente!"
    echo ""
    echo "📁 Archivos generados en: build/web/"
    echo "🌍 Para probar localmente:"
    echo "   cd build/web && python3 -m http.server 8000"
    echo "   Luego abre: http://localhost:8000/minerights.html"
    echo ""
    echo "📤 Para subir a un servidor web:"
    echo "   Sube todos los archivos de build/web/ a tu hosting"
else
    echo "❌ Error durante la exportación"
    exit 1
fi
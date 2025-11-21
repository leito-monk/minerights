#!/bin/bash
# Script para descargar templates de exportación de Godot 4.5.1

echo "📥 Descargando templates de exportación para Godot 4.5.1..."

# URL de los templates oficiales
TEMPLATES_URL="https://github.com/godotengine/godot/releases/download/4.5.1-stable/Godot_v4.5.1-stable_export_templates.tpz"

# Crear directorio temporal
mkdir -p /tmp/godot_templates

# Descargar templates
echo "🌐 Descargando desde GitHub..."
wget -O /tmp/godot_templates/templates.tpz "$TEMPLATES_URL"

if [ $? -eq 0 ]; then
    echo "✅ Descarga completada, extrayendo..."
    
    # Extraer templates
    cd /tmp/godot_templates
    unzip -q templates.tpz
    
    # Copiar a la ubicación correcta
    mkdir -p /home/le/.local/share/godot/export_templates/4.5.1.stable
    cp templates/* /home/le/.local/share/godot/export_templates/4.5.1.stable/
    
    echo "✅ Templates instalados correctamente"
    echo "📁 Ubicación: /home/le/.local/share/godot/export_templates/4.5.1.stable/"
    
    # Limpiar archivos temporales
    rm -rf /tmp/godot_templates
    
    echo "🎯 Ahora puedes ejecutar: ./build_web.sh"
else
    echo "❌ Error al descargar templates"
    echo "💡 Alternativa: Descarga manualmente desde:"
    echo "   https://github.com/godotengine/godot/releases/download/4.5.1-stable/Godot_v4.5.1-stable_export_templates.tpz"
    exit 1
fi
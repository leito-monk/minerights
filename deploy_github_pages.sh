#!/bin/bash
# Script para publicar MineRights en GitHub Pages

echo "🚀 Publicando MineRights en GitHub Pages..."

# Verificar que estamos en un repositorio git
if [ ! -d ".git" ]; then
    echo "❌ No estás en un repositorio git. Inicializando..."
    git init
    git add .
    git commit -m "Initial commit - MineRights project"
fi

# Verificar que el build existe
if [ ! -d "build/web" ]; then
    echo "❌ No se encuentra build/web/. Ejecuta ./build_web.sh primero"
    exit 1
fi

# Crear o cambiar a rama gh-pages
echo "📋 Configurando rama gh-pages..."
git checkout -b gh-pages 2>/dev/null || git checkout gh-pages

# Limpiar la rama gh-pages (mantener solo archivos web)
git rm -rf . 2>/dev/null || true

# Copiar archivos web
echo "📂 Copiando archivos web..."
cp -r build/web/* .

# Crear index.html que redirija al juego
cat > index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>MineRights - Juego de Derechos Humanos</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        h1 {
            font-size: 3em;
            margin-bottom: 10px;
        }
        .subtitle {
            font-size: 1.5em;
            margin-bottom: 30px;
            opacity: 0.9;
        }
        .play-button {
            display: inline-block;
            padding: 15px 30px;
            font-size: 1.2em;
            background: #ff6b6b;
            color: white;
            text-decoration: none;
            border-radius: 25px;
            margin: 10px;
            transition: transform 0.3s;
        }
        .play-button:hover {
            transform: scale(1.05);
        }
        .info {
            margin-top: 40px;
            padding: 20px;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
        }
        .controls {
            margin-top: 20px;
            text-align: left;
            display: inline-block;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>MINERIGHTS</h1>
        <p class="subtitle">Juego Educativo sobre Derechos Humanos y Organizacion Comunitaria</p>
        
        <a href="minerights.html" class="play-button">🎮 JUGAR AHORA</a>
        
        <div class="info">
            <h2>Sobre el Juego</h2>
            <p>MineRights es un juego educativo 3D donde aprendes sobre derechos humanos a traves de conversaciones con NPCs y organizacion comunitaria.</p>
            
            <div class="controls">
                <h3>Controles:</h3>
                <ul>
                    <li><strong>WASD</strong> - Movimiento</li>
                    <li><strong>E</strong> - Interactuar con NPCs</li>
                    <li><strong>Mouse</strong> - Camara</li>
                </ul>
            </div>
            
            <p><strong>Objetivo:</strong> Contacta a 18 NPCs unicos para aprender sobre trabajo digno, vivienda, salud y educacion.</p>
        </div>
        
        <p style="margin-top: 30px; opacity: 0.7;">
            Desarrollado con Godot 4.5.1 | Codigo abierto en GitHub
        </p>
    </div>
</body>
</html>
EOF

# Crear README específico para GitHub Pages
cat > README.md << 'EOF'
# 🎮 MineRights - Web Version

## Jugar Online
**👉 [JUGAR MINERIGHTS](https://leito-monk.github.io/minerights/)**

## Sobre el Juego
MineRights es un juego educativo 3D sobre derechos humanos y organización comunitaria.

### Características
- 18 NPCs únicos con diálogos sobre derechos fundamentales
- Sistema de organización comunitaria
- Educación sobre trabajo digno, vivienda, salud y educación
- Desarrollado en Godot 4.5.1

### Controles
- **WASD** - Movimiento
- **E** - Interactuar con NPCs
- **Mouse** - Cámara

## Tecnología
- HTML5 + WebAssembly
- Compatible con navegadores modernos
- Sin instalación requerida

## Repositorio Principal
[Ver código fuente completo](https://github.com/leito-monk/minerights)
EOF

# Agregar archivos a git
echo "📝 Agregando archivos..."
git add .
git commit -m "Deploy MineRights to GitHub Pages"

# Push a GitHub
echo "📤 Subiendo a GitHub..."
if git remote get-url origin >/dev/null 2>&1; then
    git push origin gh-pages
else
    echo "⚠️  No hay remote origin configurado."
    echo "Configura el remote con:"
    echo "git remote add origin https://github.com/TU-USUARIO/minerights.git"
    echo "Luego ejecuta: git push -u origin gh-pages"
fi

# Volver a la rama main
git checkout main

echo ""
echo "✅ ¡Deployment completado!"
echo "🌐 Tu juego estará disponible en:"
echo "   https://TU-USUARIO.github.io/minerights/"
echo ""
echo "📋 Pasos siguientes:"
echo "1. Ve a la configuración de tu repo en GitHub"
echo "2. En 'Pages', selecciona 'gh-pages' como source"
echo "3. ¡Tu juego estará online en unos minutos!"
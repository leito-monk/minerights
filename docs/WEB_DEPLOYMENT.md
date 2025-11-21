# 🌐 MineRights - Guía de Deployment Web

## 📦 **Archivos Exportados**

El juego se exportó exitosamente a `build/web/` con los siguientes archivos:

- `minerights.html` - Página principal del juego
- `minerights.js` - Motor JavaScript de Godot
- `minerights.wasm` - Binario WebAssembly del juego
- `minerights.pck` - Datos del juego empaquetados
- `minerights.png` / `minerights.icon.png` - Íconos del juego
- `minerights.audio.worklet.js` - Sistema de audio
- `minerights.apple-touch-icon.png` - Ícono para dispositivos Apple

## 🌍 **Probar Localmente**

```bash
cd build/web
python3 -m http.server 8000
```

Luego abre en tu navegador: http://localhost:8000/minerights.html

## 📤 **Deploy a Hosting Web**

### **Opción 1: GitHub Pages**
1. Sube los archivos de `build/web/` a un repo de GitHub
2. Activa GitHub Pages en la configuración del repo
3. Tu juego estará en: `https://tuusuario.github.io/repo-name/minerights.html`

### **Opción 2: Netlify**
1. Arrastra la carpeta `build/web/` a netlify.com
2. Tu juego estará disponible en una URL automática

### **Opción 3: Vercel**
1. Sube la carpeta `build/web/` a vercel.com
2. Deploy automático con URL personalizable

### **Opción 4: Tu propio servidor**
```bash
# Sube todos los archivos de build/web/ via FTP/SFTP
scp -r build/web/* usuario@tuservidor.com:/var/www/html/minerights/
```

## ⚡ **Requisitos del Navegador**

- **Soporte WebAssembly** (Chrome 57+, Firefox 52+, Safari 11+)
- **JavaScript habilitado**
- **Conexión a internet** (para carga inicial)

## 🔧 **Configuraciones Importantes**

### **Cabeceras del Servidor** (si usas tu propio hosting):
```apache
# .htaccess para Apache
<Files "*.wasm">
    Header set Content-Type application/wasm
</Files>

<Files "*.pck">
    Header set Content-Type application/octet-stream
</Files>
```

### **HTTPS Requerido**:
Muchas funciones modernas de web requieren HTTPS. Asegúrate de que tu hosting tenga SSL.

## 📱 **Compatibilidad Móvil**

El juego funciona en dispositivos móviles, pero está optimizado para:
- **Escritorio**: Controles WASD + E
- **Móvil**: Funciona pero puede requerir adaptaciones de UI

## 🎯 **URLs de Ejemplo**

Una vez deployado, los jugadores pueden acceder mediante:
- `https://tudominio.com/minerights.html`
- `https://tuusuario.github.io/minerights/minerights.html`
- `https://tu-app.netlify.app/minerights.html`

## 🚨 **Notas Importantes**

1. **Tamaño**: El juego pesa ~1.3MB comprimido
2. **Carga inicial**: Puede tardar unos segundos en dispositivos lentos
3. **Controles**: Asegúrate de informar a los usuarios sobre WASD + E
4. **Guardado**: El progreso se guarda localmente en el navegador

## ✅ **¡Listo para compartir!**

Tu juego educativo sobre derechos humanos está listo para ser jugado en cualquier navegador web moderno. 🎮✊
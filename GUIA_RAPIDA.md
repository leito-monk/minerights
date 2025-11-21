# Guía Rápida de Inicio - MineRights

## ¿Qué es MineRights?
Un juego educativo 3D sobre derechos humanos donde el jugador explora una plaza y habla con NPCs para aprender sobre diferentes derechos fundamentales.

## Requisitos
- **Godot 4.3 o superior**
- Sistema operativo: Windows, Linux, macOS
- No requiere hardware especial (low-poly)

## Inicio Rápido (5 minutos)

### 1. Clonar el Repositorio
```bash
git clone https://github.com/leito-monk/minerights.git
cd minerights
```

### 2. Abrir en Godot
1. Abrir Godot Engine 4.3+
2. Click en "Import"
3. Seleccionar `project.godot`
4. Click en "Import & Edit"

### 3. Ejecutar el Juego
- Presionar **F5** o click en el botón Play
- O ejecutar la escena principal: `scenes/main.tscn` (F6)

## Controles del Juego

| Tecla | Acción |
|-------|--------|
| **W** | Mover adelante |
| **S** | Mover atrás |
| **A** | Mover izquierda |
| **D** | Mover derecha |
| **E** | Interactuar con NPCs / Cerrar diálogo |

## Los 5 NPCs

1. 🔴 **Maestra Ana** (rojo) - Derecho a la educación
2. 🟢 **Doctor Carlos** (verde) - Derecho a la salud
3. 🔵 **Trabajadora María** (azul) - Derechos laborales
4. 🟡 **Vecino Juan** (amarillo) - Derecho a la vivienda
5. 🟣 **Activista Lucía** (magenta) - Libertad de expresión

## Objetivo del Juego
Hablar con los 5 NPCs para conocer sus mensajes sobre derechos humanos. El progreso se muestra en la esquina inferior izquierda.

## Estructura de Archivos (Para Desarrolladores)

```
minerights/
├── 📄 project.godot          # Configuración del proyecto
├── 📁 scenes/                # Escenas del juego
│   ├── main.tscn            # ⭐ Escena principal
│   ├── player.tscn          # Personaje jugador
│   └── npc.tscn             # Plantilla de NPC
├── 📁 scripts/               # Lógica del juego
│   ├── game_manager.gd      # ⭐ Coordinador principal
│   ├── player.gd            # Control del personaje
│   ├── npc.gd               # Comportamiento de NPCs
│   ├── camera_follow.gd     # Sistema de cámara
│   ├── dialog_ui.gd         # UI del diálogo
│   └── instructions_ui.gd   # UI de instrucciones
├── 📁 ui/                    # Interfaces
│   ├── dialog_ui.tscn       # Ventana de diálogo
│   └── instructions_ui.tscn # Panel de instrucciones
└── 📄 icon.svg              # Icono del proyecto
```

⭐ = Archivos principales para empezar

## Modificaciones Rápidas

### Cambiar Mensaje de un NPC
1. Abrir `scenes/main.tscn`
2. Expandir `NPCs` en el árbol de nodos
3. Seleccionar un NPC (ej: `NPC_Educacion`)
4. En el Inspector, editar `Npc Message`
5. Guardar (Ctrl+S)

### Cambiar Color de un NPC
1. Mismo proceso que arriba
2. Editar `Npc Color` en el Inspector
3. Guardar

### Agregar un Nuevo NPC
1. Abrir `scenes/main.tscn`
2. Click derecho en `NPCs` → "Instantiate Child Scene"
3. Seleccionar `scenes/npc.tscn`
4. Configurar en Inspector:
   - `Npc Name`: "Nombre"
   - `Npc Message`: "Mensaje educativo"
   - `Npc Color`: Color distintivo
5. Mover en el 3D viewport (tecla W)
6. Actualizar `total_npcs` en GameManager (nodo raíz Main)

### Cambiar Velocidad del Jugador
1. Abrir `scripts/player.gd`
2. Cambiar `const SPEED = 5.0` (línea 12)
3. Guardar y probar

## Testing

### Verificar Funcionalidad Básica
- [ ] El personaje se mueve con WASD
- [ ] La cámara sigue al personaje
- [ ] Se puede interactuar presionando E cerca de NPCs
- [ ] El diálogo muestra nombre y mensaje
- [ ] El progreso se actualiza (esquina inferior izquierda)
- [ ] Se puede cerrar el diálogo con E

### Debug Mode
Presionar **F12** durante el juego para ver:
- FPS
- Nodos en escena
- Memoria usada

## Problemas Comunes

### El juego no inicia
- ✅ Verificar que Godot sea versión 4.3+
- ✅ Verificar que `project.godot` existe
- ✅ Ver la consola de errores en Godot

### No puedo interactuar con NPCs
- ✅ Acercarse más al NPC
- ✅ Verificar que el área de detección está activa
- ✅ Presionar E (no Enter)

### El personaje se mueve muy rápido/lento
- ✅ Editar `SPEED` en `scripts/player.gd`

### La cámara no sigue al jugador
- ✅ Verificar que `target` en Camera3D apunta a Player
- ✅ Ver `scripts/camera_follow.gd` línea 27

## Recursos Adicionales

### Documentación Completa
- `DOCUMENTACION.md` - Guía completa del proyecto
- `ARQUITECTURA.md` - Diagramas y patrones de diseño

### Godot Documentation
- [Godot 4 Docs](https://docs.godotengine.org/en/stable/)
- [GDScript Reference](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/index.html)

### Comunidad
- [Godot Forum](https://forum.godotengine.org/)
- [Godot Discord](https://discord.gg/godotengine)

## Próximos Pasos

### Para Jugadores
1. ✅ Completar el objetivo (hablar con todos los NPCs)
2. Explorar la plaza
3. Leer todos los mensajes educativos

### Para Desarrolladores
1. ✅ Familiarizarse con la estructura
2. Leer `DOCUMENTACION.md` completo
3. Revisar `ARQUITECTURA.md` para entender el diseño
4. Experimentar con modificaciones simples
5. Agregar nuevas mecánicas

### Ideas para Expandir
- 🎮 Sistema de misiones
- 📦 Inventario de items
- 🎨 Mejores gráficos y efectos
- 🔊 Audio y música
- 🗺️ Más áreas para explorar
- 👥 Más NPCs con nuevos derechos
- 🏆 Sistema de logros
- 💾 Guardado de progreso

## Contacto
Para reportar bugs o sugerir mejoras, abrir un issue en el repositorio de GitHub.

## Licencia
Ver archivo `LICENSE` en el repositorio.

---

**¡Diviértete aprendiendo sobre derechos humanos!** 🎮✊

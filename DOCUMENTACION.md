# Documentación del Proyecto MineRights

## Descripción General
MineRights es un juego educativo 3D sobre derechos humanos desarrollado en Godot 4.x. El jugador explora una plaza y habla con diferentes NPCs para aprender sobre distintos derechos fundamentales.

## Estructura del Proyecto

```
minerights/
├── project.godot          # Configuración del proyecto Godot
├── scenes/                # Escenas del juego
│   ├── main.tscn         # Escena principal (plaza)
│   ├── player.tscn       # Escena del jugador
│   └── npc.tscn          # Escena base para NPCs
├── scripts/               # Scripts GDScript
│   ├── game_manager.gd   # Gestor principal del juego
│   ├── player.gd         # Controlador del personaje
│   ├── npc.gd            # Lógica de NPCs
│   ├── camera_follow.gd  # Sistema de cámara
│   ├── dialog_ui.gd      # UI del diálogo
│   └── instructions_ui.gd # UI de instrucciones
├── ui/                    # Interfaz de usuario
│   ├── dialog_ui.tscn    # Ventana de diálogo
│   └── instructions_ui.tscn # Panel de instrucciones
└── resources/             # Recursos del juego
    ├── materials/        # Materiales
    └── meshes/           # Mallas (futuras)
```

## Componentes Principales

### 1. Sistema de Jugador (player.gd)
- **Movimiento**: WASD para mover el personaje
- **Rotación**: El personaje mira hacia donde se mueve
- **Detección**: Área de detección para NPCs cercanos
- **Interacción**: Presionar E para hablar con NPCs

**Propiedades configurables:**
- `SPEED`: Velocidad de movimiento (default: 5.0)
- `ROTATION_SPEED`: Velocidad de rotación (default: 10.0)

### 2. Sistema de NPCs (npc.gd)
Cada NPC representa un derecho humano diferente:
- **Maestra Ana** (Rojo): Derecho a la educación
- **Doctor Carlos** (Verde): Derecho a la salud
- **Trabajadora María** (Azul): Derechos laborales
- **Vecino Juan** (Amarillo): Derecho a la vivienda
- **Activista Lucía** (Magenta): Libertad de expresión

**Propiedades exportadas:**
- `npc_name`: Nombre del NPC
- `npc_message`: Mensaje sobre derechos humanos
- `npc_color`: Color del cubo (estética low-poly)

**Características:**
- Estética low-poly con cubos de colores
- Etiquetas 3D flotantes con el nombre
- Efecto visual al ser contactados (emisión de luz)
- Rastrea si ya fueron contactados

### 3. Game Manager (game_manager.gd)
Coordina todos los sistemas del juego:
- Gestiona la lista de NPCs contactados
- Muestra/oculta el diálogo
- Actualiza el progreso del jugador
- Detecta cuando se completa el objetivo

**Métodos principales:**
- `_on_player_interacted_with_npc(npc)`: Maneja las interacciones
- `get_contacted_npcs()`: Retorna lista de NPCs contactados
- `get_progress()`: Retorna progreso del jugador

### 4. Sistema de Cámara (camera_follow.gd)
Cámara en tercera persona tipo isométrica:
- Sigue suavemente al jugador
- Mantiene distancia y ángulo constante
- Vista clara de la plaza

**Propiedades exportadas:**
- `target`: NodePath del objetivo a seguir
- `offset`: Offset de posición (default: Vector3(5, 7, 5))
- `smoothness`: Suavidad del seguimiento (default: 5.0)

### 5. Sistema de UI

#### Dialog UI (dialog_ui.gd)
- Muestra nombre y mensaje del NPC
- Se puede cerrar con E o botón
- Diseño centrado y claro

#### Instructions UI (instructions_ui.gd)
- Muestra controles del juego
- Indica progreso (NPCs contactados)
- Cambia color cuando se completa

## Controles del Juego

| Tecla | Acción |
|-------|--------|
| W | Mover adelante |
| S | Mover atrás |
| A | Mover izquierda |
| D | Mover derecha |
| E | Interactuar / Cerrar diálogo |

## Cómo Expandir el Juego

### Agregar Nuevos NPCs
1. En la escena principal, instanciar `npc.tscn`
2. Configurar propiedades en el inspector:
   - `npc_name`: Nombre del personaje
   - `npc_message`: Mensaje educativo
   - `npc_color`: Color distintivo
3. Posicionar en la plaza
4. Actualizar `total_npcs` en `game_manager.gd`

### Agregar Nuevas Mecánicas
El código está diseñado de forma modular:
- Cada script es independiente y bien documentado
- Las señales permiten comunicación desacoplada
- Los métodos están separados por responsabilidad

**Ejemplos de expansión:**
- **Quests**: Agregar sistema de misiones en `game_manager.gd`
- **Inventario**: Crear nuevo script `inventory.gd`
- **Mini-juegos**: Crear escenas adicionales
- **Más interacciones**: Extender `player.gd` con nuevas acciones
- **Efectos visuales**: Agregar partículas y shaders

### Modificar la Estética
El juego usa estética low-poly simple:
- Para cambiar colores: Editar `npc_color` en cada NPC
- Para cambiar formas: Reemplazar meshes en las escenas
- Para efectos: Agregar materiales con shaders simples

## Arquitectura del Código

### Señales (Signals)
- `Player.interacted_with_npc(npc)`: Emitida al presionar E cerca de un NPC

### Grupos (Groups)
- `npc_interaction`: Áreas de interacción de NPCs

### Convenciones de Código
- **Documentación**: Todos los scripts tienen comentarios de documentación
- **Tipos**: Se usan hints de tipo en GDScript (`-> void`, `: String`, etc.)
- **Naming**: snake_case para variables y métodos
- **Exports**: Variables configurables marcadas con `@export`

## Testing y Validación

Para probar el juego:
1. Abrir el proyecto en Godot 4.x
2. Presionar F5 para ejecutar
3. Verificar que:
   - El personaje se mueve con WASD
   - La cámara sigue al personaje
   - Se puede interactuar con NPCs presionando E
   - El diálogo muestra correctamente
   - El progreso se actualiza

## Notas Técnicas

### Godot Version
- **Mínimo**: Godot 4.3
- **Rendering**: Forward Plus
- **Resolución**: 1280x720 (redimensionable)

### Performance
- El juego es muy ligero (low-poly)
- No requiere hardware especial
- Puede ejecutarse en computadoras modestas

### Licencia
Software libre según LICENSE del repositorio.

## Próximos Pasos Sugeridos

1. **Fase 1 - Contenido**:
   - Agregar más NPCs con otros derechos
   - Expandir los mensajes educativos
   - Agregar referencias a documentos de derechos humanos

2. **Fase 2 - Gameplay**:
   - Sistema de misiones
   - Coleccionables (información sobre derechos)
   - Mini-juegos educativos

3. **Fase 3 - Visuales**:
   - Efectos de partículas
   - Mejor iluminación
   - Animaciones de personajes

4. **Fase 4 - Audio**:
   - Música de fondo
   - Efectos de sonido
   - Voces opcionales

5. **Fase 5 - Social**:
   - Sistema de organización comunitaria
   - Acciones colectivas
   - Transformación visual del mundo

## Contacto y Contribuciones
Este es un proyecto de código abierto. Las contribuciones son bienvenidas siguiendo las convenciones establecidas en esta documentación.

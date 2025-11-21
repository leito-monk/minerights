# Arquitectura del Juego MineRights

## Diagrama de Escenas

```
Main (Node3D)
├── GameManager (Node)
│   └── Coordina interacciones, rastrea NPCs contactados
│
├── Environment (Node3D)
│   ├── DirectionalLight3D (luz del sol)
│   └── WorldEnvironment (configuración de entorno)
│
├── Plaza (Node3D)
│   └── Ground (MeshInstance3D - Plano 30x30)
│
├── Player (CharacterBody3D)
│   ├── MeshInstance3D (Cápsula - personaje)
│   ├── CollisionShape3D (física del personaje)
│   └── DetectionArea (Area3D - detecta NPCs cercanos)
│       └── CollisionShape3D (esfera radio 2.5)
│
├── Camera3D
│   └── Sigue al jugador con offset (5, 7, 5)
│
├── NPCs (Node3D)
│   ├── NPC_Educacion (Maestra Ana - Rojo)
│   ├── NPC_Salud (Doctor Carlos - Verde)
│   ├── NPC_Trabajo (Trabajadora María - Azul)
│   ├── NPC_Vivienda (Vecino Juan - Amarillo)
│   └── NPC_Libertad (Activista Lucía - Magenta)
│
└── UI (CanvasLayer)
    ├── DialogUI (ventana de diálogo)
    └── InstructionsUI (panel de instrucciones)
```

## Estructura de un NPC

```
NPC (Node3D) [script: npc.gd]
├── MeshInstance3D (Cubo 1x2x1)
├── Label3D (nombre flotante)
└── InteractionArea (Area3D)
    └── CollisionShape3D (caja 1x2x1)
```

## Flujo de Interacción

```
1. Player se acerca al NPC
   ↓
2. DetectionArea detecta InteractionArea del NPC
   ↓
3. Player.nearby_npc = NPC
   ↓
4. Jugador presiona E
   ↓
5. Player emite señal interacted_with_npc(NPC)
   ↓
6. GameManager recibe la señal
   ↓
7. GameManager obtiene datos del NPC
   ↓
8. NPC se marca como contactado (primera vez)
   ↓
9. GameManager registra NPC en lista
   ↓
10. GameManager muestra DialogUI con datos
    ↓
11. InstructionsUI actualiza progreso
```

## Flujo de Datos

```
                    ┌─────────────┐
                    │ GameManager │
                    └──────┬──────┘
                           │
                           │ coordina
                           │
         ┌─────────────────┼─────────────────┐
         │                 │                 │
         ▼                 ▼                 ▼
    ┌────────┐        ┌────────┐       ┌──────┐
    │ Player │        │  NPCs  │       │  UI  │
    └────┬───┘        └───┬────┘       └───┬──┘
         │                │                │
         │ interactúa     │ provee         │ muestra
         │ con            │ datos          │ info
         │                │                │
         └────────────────┴────────────────┘
```

## Sistema de Señales

```
Player (CharacterBody3D)
    └─ signal: interacted_with_npc(npc: Node3D)
              │
              │ conectada a
              ▼
       GameManager._on_player_interacted_with_npc(npc)
```

## Componentes Modulares

### 1. Movimiento (player.gd)
- Input handling (WASD)
- Física (velocity, gravity)
- Rotación suave
- Independiente de otros sistemas

### 2. Detección (player.gd)
- Area3D para detectar proximidad
- Grupos para identificar NPCs
- Variable `nearby_npc` para referencia

### 3. NPCs (npc.gd)
- Propiedades exportadas (configurables)
- Estado interno (has_been_contacted)
- Interfaz pública (get_dialog_data, mark_as_contacted)
- Auto-configuración visual en _ready()

### 4. Coordinación (game_manager.gd)
- Punto central de lógica
- No maneja inputs directamente
- Gestiona estado global (lista de NPCs)
- Actualiza UI

### 5. UI (dialog_ui.gd, instructions_ui.gd)
- Presentación pura
- Recibe datos, no los genera
- Métodos públicos para actualización

### 6. Cámara (camera_follow.gd)
- Totalmente independiente
- Solo necesita referencia al target
- No interfiere con otros sistemas

## Ventajas de esta Arquitectura

### ✅ Modularidad
Cada componente tiene responsabilidad única y clara.

### ✅ Extensibilidad
Fácil agregar:
- Nuevos NPCs (instanciar + configurar)
- Nuevas mecánicas (nuevos scripts)
- Nuevas UIs (nuevas escenas)

### ✅ Mantenibilidad
- Código documentado
- Separación de concerns
- Bajo acoplamiento

### ✅ Reutilización
- npc.tscn es una plantilla
- Scripts son independientes
- UI puede reutilizarse en otras escenas

## Puntos de Extensión

### Para agregar nuevas mecánicas:

1. **Sistema de Inventario**
   - Crear `inventory.gd` (manager)
   - Agregar señales en Player
   - Crear UI de inventario
   - NPCs pueden dar items

2. **Sistema de Quests**
   - Crear `quest_manager.gd`
   - Extender NPCs con quest_data
   - Agregar UI de quests
   - Integrar con GameManager

3. **Sistema de Diálogo Avanzado**
   - Crear `dialog_tree.gd`
   - Opciones múltiples
   - Ramificaciones
   - Consecuencias

4. **Mini-juegos Educativos**
   - Crear escenas separadas
   - Integrar con NPCs
   - Sistema de recompensas
   - Resultados afectan progreso

5. **Transformación del Mundo**
   - Variables de estado en GameManager
   - NPCs pueden cambiar el mundo
   - Efectos visuales progresivos
   - Nuevas áreas desbloqueables

## Patrones de Diseño Utilizados

### Observer Pattern
- Señales de Godot (interacted_with_npc)
- Desacopla Player de GameManager

### Component Pattern
- Cada nodo 3D tiene componentes
- Area3D para detección
- MeshInstance3D para visuales
- CollisionShape3D para física

### Template Method
- npc.tscn como plantilla base
- Instancias configuradas en main.tscn
- Mismo comportamiento, datos diferentes

### Singleton Pattern
- GameManager como coordinador central
- Único punto de acceso al estado global

## Convenciones de Código

### Naming
- `snake_case` para todo
- `UPPER_CASE` para constantes
- Prefijos claros (`npc_`, `_on_`)

### Documentación
- `##` para documentación de clase/método
- `#` para comentarios inline
- Hints de tipo siempre (`-> void`, `: String`)

### Organización
- `_ready()` primero
- `_process()/_physics_process()` después
- Callbacks (`_on_*`) juntos
- Métodos públicos al final

### Exports
- Variables configurables con `@export`
- Valores por defecto razonables
- Descripción clara del propósito

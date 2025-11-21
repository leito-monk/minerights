# Organización del Repositorio MineRights

## 📂 Estructura Final

```
minerights/
├── README.md                 # Documentación principal del proyecto
├── project.godot            # Configuración principal de Godot
├── LICENSE                  # Licencia del proyecto
├── ARQUITECTURA.md          # Documentación de arquitectura
├── DOCUMENTACION.md         # Documentación técnica
├── GUIA_RAPIDA.md          # Guía de inicio rápido
├── RESUMEN_IMPLEMENTACION.md # Resumen de implementación
├── VISUAL_GUIDE.md         # Guía visual
├── icon.svg                # Ícono del proyecto
├── scenes/                 # Escenas principales (CORE)
│   ├── main_menu.tscn      # Menú principal
│   ├── main_fixed.tscn     # Escena completa del juego
│   ├── npc.tscn           # Prefab de NPC
│   └── meeting_node.tscn   # Nodo de reunión
├── scripts/                # Scripts principales (CORE)
│   ├── game_state.gd       # Estado global (singleton)
│   ├── game_manager.gd     # Coordinador principal
│   ├── player_fixed.gd     # Controlador del jugador
│   ├── player.gd          # Versión alternativa del jugador
│   ├── npc.gd             # Comportamiento de NPCs
│   ├── main_menu.gd       # Lógica del menú
│   └── [otros scripts UI]
├── ui/                     # Interfaces de usuario
│   ├── dialog_ui.tscn      # Sistema de diálogo
│   ├── instructions_ui.tscn # Instrucciones
│   └── [otros UIs]
├── docs/                   # Documentación de desarrollo
│   ├── README_OLD.md       # README anterior
│   └── [documentos de troubleshooting]
└── archive/                # Archivos obsoletos
    ├── scenes/             # Versiones antiguas de escenas
    └── scripts/            # Scripts obsoletos/de prueba
```

## ✨ Archivos Core del Proyecto

### Escenas Principales
- `scenes/main_menu.tscn` → Punto de entrada del juego
- `scenes/main_fixed.tscn` → Escena completa con 18 NPCs

### Scripts Esenciales  
- `scripts/game_state.gd` → Singleton con datos globales
- `scripts/game_manager.gd` → Coordinador de interacciones
- `scripts/player_fixed.gd` → Control principal del jugador

## 📋 Archivos Movidos

### A docs/
- Toda la documentación de troubleshooting y desarrollo temporal

### A archive/
- `scenes/game_test.tscn` y variantes de prueba
- `scripts/player_debug.gd` y versiones de desarrollo
- Archivos `*_enhanced.gd`, `*_simple.gd`, etc.

## 🎯 Configuración Actual

- **Main Scene**: `scenes/main_menu.tscn`
- **Juego Principal**: `scenes/main_fixed.tscn` (18 NPCs)
- **Singleton**: `GameState` (`scripts/game_state.gd`)

## ⚡ Próximos Pasos

El proyecto está listo para desarrollo adicional con una estructura limpia y organizada.
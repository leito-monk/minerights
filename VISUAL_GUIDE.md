# Guía Visual del Juego MineRights

## Vista General del Juego

```
┌──────────────────────────────────────────────────────────────────┐
│                         MineRights                               │
│                                                                  │
│                        ☀️ (Luz del Sol)                         │
│                                                                  │
│                                                                  │
│         🟥 Maestra Ana                    🟣 Activista Lucía    │
│         (Educación)                       (Libertad)            │
│                                                                  │
│                                                                  │
│                          👤 JUGADOR                              │
│                       (Cápsula Azul)                             │
│                                                                  │
│                                                                  │
│         🟦 Trabajadora María            🟢 Doctor Carlos        │
│         (Trabajo)                        (Salud)                 │
│                                                                  │
│                                                                  │
│         🟨 Vecino Juan                                           │
│         (Vivienda)                                               │
│                                                                  │
│                    🟩🟩🟩 PLAZA 🟩🟩🟩                          │
│                   (Suelo Plano Verde)                            │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘

Vista desde arriba - Los NPCs están distribuidos en la plaza
```

## Vista en Tercera Persona (Cámara)

```
            📷 Cámara
              ↗
             /
            /
           /
          🌍 Plaza con NPCs
           ╲
            ╲
             ↘
              👤 Jugador
```

La cámara está posicionada detrás y arriba del jugador (offset 5, 7, 5)
dando una vista isométrica clara de la escena.

## Personaje Jugador

```
      ┌─┐
      │ │  ← Cabeza (parte superior de la cápsula)
      │ │
      │ │  ← Cuerpo (cápsula azul)
      │ │
      │ │
      └─┘  ← Pies
      
Color: Azul (0.2, 0.5, 0.8)
Forma: Cápsula vertical (radio 0.5, altura 2.0)
Detección: Esfera invisible de radio 2.5 alrededor
```

## NPCs (Cubos Low-Poly)

```
      ┌───────────┐
      │           │
      │  "Nombre" │  ← Label3D flotante
      │           │
      ├───────────┤
      │           │
      │    ███    │  ← Cubo de color sólido
      │    ███    │
      │    ███    │
      │           │
      └───────────┘
      
Tamaño: 1x2x1 (ancho x alto x profundidad)
Estilo: Sin sombras suaves (unshaded) - estética low-poly
Colores únicos para cada NPC
```

### Los 5 NPCs

1. **🟥 Maestra Ana** (Rojo)
   - Posición: Esquina superior izquierda (-6, 1, -6)
   - Mensaje: Derecho a la educación

2. **🟢 Doctor Carlos** (Verde)
   - Posición: Esquina superior derecha (6, 1, -6)
   - Mensaje: Derecho a la salud

3. **🟦 Trabajadora María** (Azul)
   - Posición: Esquina inferior izquierda (-6, 1, 6)
   - Mensaje: Derechos laborales

4. **🟨 Vecino Juan** (Amarillo)
   - Posición: Esquina inferior derecha (6, 1, 6)
   - Mensaje: Derecho a la vivienda

5. **🟣 Activista Lucía** (Magenta)
   - Posición: Centro superior (0, 1, -8)
   - Mensaje: Libertad de expresión

## Distribución en la Plaza

```
        ↑ Z negativo (Norte)
        │
        │
    🟥  │  🟣  │  🟢
        │      │
────────┼──────┼────────→ X positivo (Este)
        │      │
    🟦  │  👤  │  🟨
        │      │
        │
        ↓ Z positivo (Sur)

Plaza: 30x30 unidades
Suelo: Verde claro (0.4, 0.6, 0.4)
```

## UI - Instrucciones (Esquina Inferior Izquierda)

```
┌─────────────────────────────────────┐
│ CONTROLES:                          │
│ WASD - Movimiento                   │
│ E - Interactuar con NPCs            │
│                                     │
│ OBJETIVO:                           │
│ Habla con todos los NPCs para       │
│ aprender sobre derechos humanos     │
│ ─────────────────────────────────   │
│ NPCs contactados: 0/5               │
│    (Verde cuando completo)          │
└─────────────────────────────────────┘
```

## UI - Diálogo (Centro de Pantalla)

```
           ┌──────────────────────────────────────┐
           │                                      │
           │        Maestra Ana                   │
           │        (Nombre en dorado)            │
           ├──────────────────────────────────────┤
           │                                      │
           │  La educación es un derecho          │
           │  fundamental. Toda persona tiene     │
           │  derecho a la educación gratuita     │
           │  y de calidad. La educación nos      │
           │  libera y nos permite desarrollar-   │
           │  nos plenamente.                     │
           │                                      │
           ├──────────────────────────────────────┤
           │          [ Cerrar (E) ]              │
           └──────────────────────────────────────┘
```

## Efectos Visuales

### NPC No Contactado
```
┌─────┐
│     │  ← Color sólido
│ ███ │     Sin efectos
│ ███ │
│ ███ │
└─────┘
```

### NPC Contactado
```
┌─────┐
│  ✨  │  ← Emisión de luz (30% del color)
│ ███ │     Brilla suavemente
│ ███ │
│ ███ │
└─────┘
```

## Flujo Visual de Juego

### 1. Inicio
```
👤 Jugador aparece en el centro de la plaza
📋 UI de instrucciones visible
🎯 5 NPCs esperando

NPCs contactados: 0/5
```

### 2. Aproximación a NPC
```
👤 → 🟥
     ↑
   2.5 unidades
   (rango de detección)

"nearby_npc" se activa
Listo para presionar E
```

### 3. Interacción
```
Presiona E
    ↓
Aparece diálogo centrado
    ↓
Lee el mensaje
    ↓
Presiona E para cerrar
    ↓
NPC brilla (emisión de luz)
    ↓
Progreso: 1/5
```

### 4. Completado
```
NPCs contactados: 5/5 ✅ (Verde)

"¡Felicitaciones! Has hablado con todos los NPCs."
```

## Paleta de Colores

### NPCs
- 🟥 Rojo: `(0.8, 0.3, 0.3)` - Educación
- 🟢 Verde: `(0.3, 0.8, 0.3)` - Salud
- 🟦 Azul: `(0.3, 0.3, 0.8)` - Trabajo
- 🟨 Amarillo: `(0.8, 0.8, 0.3)` - Vivienda
- 🟣 Magenta: `(0.8, 0.3, 0.8)` - Libertad

### Jugador
- 🔵 Azul claro: `(0.2, 0.5, 0.8)`

### Entorno
- 🟩 Suelo: `(0.4, 0.6, 0.4)` - Verde césped

### UI
- ⬜ Fondo paneles: Gris oscuro (default)
- 🟡 Nombre NPC: Dorado `(1.0, 0.8, 0.2)`
- ⬜ Texto: Blanco
- 🟢 Progreso completo: Verde

## Iluminación

```
      ☀️ DirectionalLight3D
       │
       │ 45° ángulo
       ↓
    🌍 Escena

- Luz direccional simulando el sol
- Sombras habilitadas
- Iluminación uniforme en la plaza
```

## Dimensiones y Escala

```
Jugador:
- Altura: 2.0 unidades (cápsula)
- Radio: 0.5 unidades

NPCs:
- Ancho: 1.0 unidad
- Alto: 2.0 unidades
- Profundo: 1.0 unidad

Plaza:
- Tamaño: 30x30 unidades
- Altura: 0 (plano)

Cámara:
- Distancia: ~8.66 unidades desde el jugador
- Altura: 7 unidades
- FOV: 60°
```

## Aspecto Final

El juego tiene un estilo visual minimalista y educativo:
- ✅ Colores claros y diferenciados
- ✅ Formas geométricas simples (low-poly)
- ✅ UI clara y legible
- ✅ Enfoque en el contenido educativo
- ✅ Sin distracciones visuales innecesarias

## Comparación de Estilos

```
❌ NO usar:
- Realismo
- Texturas complejas
- Muchos polígonos
- Efectos pesados

✅ SÍ usar:
- Low-poly
- Colores sólidos
- Formas simples
- UI minimalista
```

## Expansión Visual Futura

Ideas para mejorar la estética manteniendo el estilo:
1. **Partículas simples** al contactar NPCs
2. **Senderos** en el suelo entre NPCs
3. **Objetos decorativos** low-poly (árboles, bancos)
4. **Skybox** simple con degradado
5. **Animaciones** suaves de NPCs (bounce leve)
6. **Efectos de texto** flotante sobre NPCs cercanos

Todo manteniendo la filosofía low-poly y el enfoque educativo.

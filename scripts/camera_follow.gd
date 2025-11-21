extends Camera3D
## Cámara que sigue al personaje en tercera persona.
##
## Mantiene una posición fija relativa al jugador y mira hacia él.
## La cámara está configurada para una vista de tercera persona tipo isométrica.

# Objetivo a seguir (el jugador)
@export var target: NodePath

# Offset de la cámara respecto al objetivo
@export var offset: Vector3 = Vector3(5, 7, 5)

# Suavidad del seguimiento
@export var smoothness: float = 5.0

# Referencia al nodo objetivo
var target_node: Node3D = null


func _ready() -> void:
	# Obtener referencia al objetivo
	if target:
		target_node = get_node(target)


func _physics_process(delta: float) -> void:
	if not target_node:
		return
	
	# Calcular posición objetivo de la cámara
	var target_position = target_node.global_position + offset
	
	# Mover la cámara suavemente hacia la posición objetivo
	global_position = global_position.lerp(target_position, smoothness * delta)
	
	# Hacer que la cámara siempre mire al jugador
	look_at(target_node.global_position, Vector3.UP)

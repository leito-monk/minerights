extends CharacterBody3D
## Controlador del personaje jugador en tercera persona.
##
## Este script maneja el movimiento del personaje usando WASD,
## detección de NPCs cercanos para interacción y comunicación
## con el sistema de diálogo.

# Constantes de movimiento
const SPEED = 5.0
const ROTATION_SPEED = 10.0

# Referencia al NPC más cercano con el que se puede interactuar
var nearby_npc: Node3D = null

# Señal emitida cuando el jugador interactúa con un NPC
signal interacted_with_npc(npc: Node3D)


func _ready() -> void:
	# Configuración inicial del personaje
	pass


func _physics_process(delta: float) -> void:
	# Obtener input del jugador
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := Vector3(input_dir.x, 0, -input_dir.y).normalized()
	
	# Aplicar movimiento
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# Rotar el personaje hacia la dirección de movimiento
		var target_rotation = atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, ROTATION_SPEED * delta)
	else:
		# Frenar el personaje cuando no hay input
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# Aplicar gravedad (aunque el suelo es plano, por coherencia física)
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	# Detectar input de interacción (tecla E)
	if event.is_action_pressed("interact") and nearby_npc != null:
		emit_signal("interacted_with_npc", nearby_npc)


## Método llamado por el área de detección cuando un NPC entra en rango
func _on_detection_area_entered(area: Area3D) -> void:
	if area.is_in_group("npc_interaction"):
		nearby_npc = area.get_parent()


## Método llamado por el área de detección cuando un NPC sale del rango
func _on_detection_area_exited(area: Area3D) -> void:
	if area.is_in_group("npc_interaction") and area.get_parent() == nearby_npc:
		nearby_npc = null

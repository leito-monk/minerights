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

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	print("Jugador listo - Usa WASD para moverte, E para interactuar")

func _physics_process(delta: float) -> void:
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	
	# Obtener input del jugador
	var input_dir := Vector3.ZERO
	
	# Movimiento con WASD
	if Input.is_action_pressed("move_forward"):
		input_dir.z -= 1
	if Input.is_action_pressed("move_backward"):
		input_dir.z += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	
	# Normalizar la dirección para movimiento diagonal consistente
	var direction = input_dir.normalized()
	
	# Aplicar movimiento horizontal
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# Rotar el personaje hacia la dirección de movimiento
		var target_rotation = atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, ROTATION_SPEED * delta)
		
		# Comentado para reducir spam en consola
		# print("Moviendo - Pos: ", global_position, " Vel: ", velocity)
	else:
		# Frenar el personaje cuando no hay input
		velocity.x = move_toward(velocity.x, 0, SPEED * 3)
		velocity.z = move_toward(velocity.z, 0, SPEED * 3)
	
	# Ejecutar movimiento
	move_and_slide()

func _input(event: InputEvent) -> void:
	# Detectar input de interacción (tecla E)
	if Input.is_action_just_pressed("interact"):
		# Buscar diálogo usando el GameManager
		var game_manager = get_node("../GameManager")
		if game_manager and game_manager.dialog_ui and game_manager.dialog_ui.visible:
			# Si el diálogo está abierto, no interactuar (dejar que el diálogo maneje el evento)
			return
		
		if nearby_npc != null:
			print("Player: Interactuando con NPC: ", nearby_npc.npc_name)
			emit_signal("interacted_with_npc", nearby_npc)
		else:
			print("Player: No hay NPC cercano para interactuar")

## Método llamado por el área de detección cuando un NPC entra en rango
func _on_detection_area_entered(area: Area3D) -> void:
	if area.is_in_group("npc_interaction"):
		nearby_npc = area.get_parent()
		print("NPC detectado: ", nearby_npc.npc_name if nearby_npc.has_method("get") else "Sin nombre")

## Método llamado por el área de detección cuando un NPC sale del rango
func _on_detection_area_exited(area: Area3D) -> void:
	if area.is_in_group("npc_interaction") and area.get_parent() == nearby_npc:
		nearby_npc = null
		print("NPC fuera de rango")
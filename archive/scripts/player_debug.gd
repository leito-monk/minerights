extends CharacterBody3D
## Script de debug simple para el jugador

const SPEED = 5.0

func _ready() -> void:
	print("=== PLAYER DEBUG ===")
	print("Player cargado exitosamente!")
	print("Posición inicial: ", global_position)
	print("Nodo válido: ", is_inside_tree())

func _physics_process(delta: float) -> void:
	# Movimiento ultra-simple para debug
	var input_vector = Vector3.ZERO
	
	# Detectar teclas directamente
	if Input.is_key_pressed(KEY_W):
		input_vector.z -= 1
		print("Presionando W")
	if Input.is_key_pressed(KEY_S):
		input_vector.z += 1
		print("Presionando S")
	if Input.is_key_pressed(KEY_A):
		input_vector.x -= 1
		print("Presionando A")
	if Input.is_key_pressed(KEY_D):
		input_vector.x += 1
		print("Presionando D")
	
	if input_vector != Vector3.ZERO:
		velocity.x = input_vector.x * SPEED
		velocity.z = input_vector.z * SPEED
		print("Aplicando velocidad: ", velocity)
	else:
		velocity.x = 0
		velocity.z = 0
	
	# Gravedad básica
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0
	
	# Ejecutar movimiento
	var old_pos = global_position
	move_and_slide()
	
	if old_pos.distance_to(global_position) > 0.001:
		print("MOVIMIENTO DETECTADO: ", old_pos, " -> ", global_position)
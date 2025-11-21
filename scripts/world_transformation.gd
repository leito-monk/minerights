extends Node3D

# Sistema de transformación visual del mundo según derechos conquistados

var world_environment: Environment
var default_sky_color = Color(0.5, 0.7, 0.9)  # Azul grisáceo inicial
var victory_sky_color = Color(0.9, 0.8, 0.5)   # Dorado de victoria

# Efectos visuales por derecho conquistado
var transformation_effects = {
	"Derecho a la Salud": {
		"sky_tint": Color(0.7, 0.9, 0.7),      # Verde salud
		"ground_color": Color(0.3, 0.6, 0.3),
		"description": "El aire se vuelve más limpio, aparecen espacios verdes"
	},
	"Derecho a la Educación": {
		"sky_tint": Color(0.7, 0.7, 0.9),      # Azul conocimiento
		"ground_color": Color(0.4, 0.4, 0.7),
		"description": "Aparecen estructuras educativas, bibliotecas virtuales"
	},
	"Derecho a la Vivienda": {
		"sky_tint": Color(0.9, 0.8, 0.6),      # Cálido hogar
		"ground_color": Color(0.6, 0.5, 0.4),
		"description": "Se materializan hogares dignos, espacios habitables"
	},
	"Derecho al Trabajo Digno": {
		"sky_tint": Color(0.8, 0.9, 0.7),      # Verde esperanza
		"ground_color": Color(0.5, 0.6, 0.4),
		"description": "Surgen espacios de trabajo colaborativo y digno"
	}
}

# Referencias a materiales del mundo
var ground_material: StandardMaterial3D
var building_materials: Array[StandardMaterial3D] = []

func _ready():
	# Conectar señales del GameState
	GameState.right_conquered.connect(_on_right_conquered)
	
	# Configurar environment inicial
	_setup_world_environment()
	_gather_world_materials()
	
	print("Sistema de transformación visual inicializado")

func _setup_world_environment():
	# Obtener o crear el Environment del mundo
	var main_camera = get_viewport().get_camera_3d()
	if main_camera:
		world_environment = main_camera.environment
		if not world_environment:
			world_environment = Environment.new()
			main_camera.environment = world_environment
		
		# Configurar cielo inicial
		world_environment.background_mode = Environment.BG_SKY
		var sky = Sky.new()
		var procedural_sky = ProceduralSkyMaterial.new()
		procedural_sky.sky_top_color = default_sky_color
		procedural_sky.sky_horizon_color = default_sky_color.darkened(0.3)
		sky.sky_material = procedural_sky
		world_environment.sky = sky

func _gather_world_materials():
	# Buscar y recopilar materiales del mundo para transformar
	_find_ground_materials(get_tree().root)
	_find_building_materials(get_tree().root)

func _find_ground_materials(node: Node):
	# Buscar materiales del suelo (planos, mesh instances con nombres específicos)
	if node is MeshInstance3D:
		var mesh_instance = node as MeshInstance3D
		if "ground" in node.name.to_lower() or "floor" in node.name.to_lower():
			var material = mesh_instance.get_surface_override_material(0)
			if material is StandardMaterial3D:
				ground_material = material
	
	for child in node.get_children():
		_find_ground_materials(child)

func _find_building_materials(node: Node):
	# Buscar materiales de edificios y estructuras
	if node is MeshInstance3D:
		var mesh_instance = node as MeshInstance3D
		if "building" in node.name.to_lower() or "structure" in node.name.to_lower():
			var material = mesh_instance.get_surface_override_material(0)
			if material is StandardMaterial3D:
				building_materials.append(material)
	
	for child in node.get_children():
		_find_building_materials(child)

func _on_right_conquered(right_name: String):
	print("Aplicando transformación visual para: %s" % right_name)
	
	var effect_data = transformation_effects.get(right_name, {})
	if effect_data.is_empty():
		return
	
	# Transformar el cielo
	_transform_sky(effect_data.get("sky_tint", Color.WHITE))
	
	# Transformar el suelo
	_transform_ground(effect_data.get("ground_color", Color.WHITE))
	
	# Crear efectos especiales
	_create_conquest_effects(right_name)
	
	# Verificar si se conquistaron todos los derechos
	_check_complete_transformation()

func _transform_sky(sky_tint: Color):
	if world_environment and world_environment.sky:
		var sky_material = world_environment.sky.sky_material as ProceduralSkyMaterial
		if sky_material:
			var tween = create_tween()
			tween.set_parallel(true)
			
			# Transición gradual del color del cielo
			var current_color = sky_material.sky_top_color
			var target_color = current_color.lerp(sky_tint, 0.7)
			
			tween.tween_method(_set_sky_color, current_color, target_color, 3.0)

func _set_sky_color(color: Color):
	if world_environment and world_environment.sky:
		var sky_material = world_environment.sky.sky_material as ProceduralSkyMaterial
		if sky_material:
			sky_material.sky_top_color = color
			sky_material.sky_horizon_color = color.darkened(0.3)

func _transform_ground(ground_color: Color):
	if ground_material:
		var tween = create_tween()
		var current_color = ground_material.albedo_color
		var target_color = current_color.lerp(ground_color, 0.5)
		
		tween.tween_method(_set_ground_color, current_color, target_color, 2.0)

func _set_ground_color(color: Color):
	if ground_material:
		ground_material.albedo_color = color

func _create_conquest_effects(right_name: String):
	# Crear efectos visuales específicos para cada derecho
	match right_name:
		"Derecho a la Salud":
			_create_health_effects()
		"Derecho a la Educación":
			_create_education_effects()
		"Derecho a la Vivienda":
			_create_housing_effects()
		"Derecho al Trabajo Digno":
			_create_work_effects()

func _create_health_effects():
	# Efectos de salud: partículas verdes, "purificación" del aire
	_spawn_particle_effect(Color.GREEN, "Aire más limpio")

func _create_education_effects():
	# Efectos de educación: símbolos de conocimiento, libros virtuales
	_spawn_particle_effect(Color.BLUE, "Conocimiento se expande")

func _create_housing_effects():
	# Efectos de vivienda: estructuras emergentes, cálidos colores
	_spawn_particle_effect(Color(0.9, 0.6, 0.3), "Hogares dignos emergen")

func _create_work_effects():
	# Efectos de trabajo: herramientas, espacios colaborativos
	_spawn_particle_effect(Color(0.8, 0.8, 0.2), "Trabajo digno florece")

func _spawn_particle_effect(color: Color, description: String):
	# Crear un efecto de partículas simple usando nodos
	var effect_container = Node3D.new()
	effect_container.name = "ConquestEffect_" + description.replace(" ", "_")
	get_tree().root.add_child(effect_container)
	
	# Crear múltiples esferas brillantes como "partículas"
	for i in range(20):
		var particle = MeshInstance3D.new()
		var sphere = SphereMesh.new()
		sphere.radius = 0.1
		particle.mesh = sphere
		
		var material = StandardMaterial3D.new()
		material.albedo_color = color
		material.emission_enabled = true
		material.emission = color
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		particle.set_surface_override_material(0, material)
		
		# Posición aleatoria en el aire
		particle.position = Vector3(
			randf_range(-20, 20),
			randf_range(3, 8),
			randf_range(-20, 20)
		)
		
		effect_container.add_child(particle)
		
		# Animar las partículas
		var tween = create_tween()
		tween.set_parallel(true)
		
		# Movimiento flotante
		tween.tween_property(particle, "position:y", particle.position.y + randf_range(2, 5), 3.0)
		
		# Fade out
		tween.tween_property(material, "albedo_color:a", 0.0, 4.0)
		tween.tween_property(material, "emission:a", 0.0, 4.0)
	
	# Eliminar el contenedor después de la animación
	await get_tree().create_timer(5.0).timeout
	effect_container.queue_free()
	
	print("Efecto visual creado: %s" % description)

func _check_complete_transformation():
	var conquered_count = GameState.get_conquered_rights_count()
	
	if conquered_count >= 4:  # Todos los derechos conquistados
		_trigger_victory_transformation()

func _trigger_victory_transformation():
	print("¡TODOS LOS DERECHOS CONQUISTADOS! Transformación completa del mundo.")
	
	# Transformación dramática del mundo completo
	if world_environment and world_environment.sky:
		var sky_material = world_environment.sky.sky_material as ProceduralSkyMaterial
		if sky_material:
			var tween = create_tween()
			tween.set_parallel(true)
			
			# Cielo dorado de victoria
			tween.tween_property(sky_material, "sky_top_color", victory_sky_color, 5.0)
			tween.tween_property(sky_material, "sky_horizon_color", victory_sky_color.darkened(0.2), 5.0)
	
	# Efectos especiales de victoria
	_create_victory_celebration()

func _create_victory_celebration():
	# Gran celebración visual - múltiples colores, efectos dramáticos
	var celebration_colors = [
		Color.GOLD,
		Color.ORANGE, 
		Color.YELLOW,
		Color.LIME_GREEN,
		Color.CYAN,
		Color.MAGENTA
	]
	
	for color in celebration_colors:
		await get_tree().create_timer(0.5).timeout
		_spawn_particle_effect(color, "Victoria Total - Mundo Transformado")
	
	print("🎉 ¡CELEBRACIÓN DE VICTORIA! El mundo ha sido completamente transformado por la lucha colectiva.")
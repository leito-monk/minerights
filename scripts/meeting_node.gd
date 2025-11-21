extends Area3D
## Nodo de Encuentro - Zona donde se forman asambleas y grupos organizados
##
## Cuando el jugador trae 3+ NPCs de la misma categoría a esta zona,
## se activa una asamblea y se forma un grupo organizado.

@export var node_name: String = "Plaza Central"
@export var node_type: String = "plaza" # plaza, centro_comunitario, etc.
@export var required_npcs: int = 3

# Referencias visuales
@onready var area_indicator: MeshInstance3D = null
@onready var name_label: Label3D = null

# Estado del nodo
var active_categories: Dictionary = {} # {categoria: count}
var players_in_area: Array = []

func _ready() -> void:
	print("Nodo de encuentro '%s' inicializado" % node_name)
	
	_setup_visual_indicators()
	_connect_signals()

func _setup_visual_indicators() -> void:
	# Crear indicador visual del área
	area_indicator = MeshInstance3D.new()
	var cylinder = CylinderMesh.new()
	cylinder.top_radius = 3.0
	cylinder.bottom_radius = 3.0
	cylinder.height = 0.1
	area_indicator.mesh = cylinder
	
	# Material semitransparente
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.2, 0.8, 0.4, 0.3)
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.no_depth_test = false
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	area_indicator.set_surface_override_material(0, material)
	
	add_child(area_indicator)
	
	# Crear label con el nombre
	name_label = Label3D.new()
	name_label.text = node_name
	name_label.position = Vector3(0, 1, 0)
	name_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	name_label.font_size = 48
	add_child(name_label)

func _connect_signals() -> void:
	# Conectar señales del área
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Conectar señales del GameState
	GameState.npc_contacted.connect(_on_npc_contacted)

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("get_script") and body.get_script():
		var script_path = body.get_script().get_path()
		if "player" in script_path:
			players_in_area.append(body)
			print("Jugador entró en %s" % node_name)
			_check_assembly_conditions()

func _on_body_exited(body: Node3D) -> void:
	if body in players_in_area:
		players_in_area.erase(body)
		print("Jugador salió de %s" % node_name)

func _on_npc_contacted(npc_data: Dictionary) -> void:
	# Cuando se contacta un NPC, verificar si se pueden formar grupos
	if not players_in_area.is_empty():
		_check_assembly_conditions()

func _check_assembly_conditions() -> void:
	if players_in_area.is_empty():
		return
	
	# Contar NPCs contactados por categoría
	var category_counts = _count_contacted_npcs_by_category()
	
	# Verificar cada categoría
	for category in category_counts.keys():
		var count = category_counts[category]
		if count >= required_npcs:
			_attempt_assembly_formation(category, count)

func _count_contacted_npcs_by_category() -> Dictionary:
	var counts = {}
	
	# Inicializar contadores
	for category in GameState.NPCCategory.values():
		counts[category] = 0
	
	# Contar NPCs contactados
	for npc_data in GameState.contacted_npcs:
		var category = npc_data.get("category", GameState.NPCCategory.TRABAJO_PRECARIO)
		counts[category] += 1
	
	return counts

func _attempt_assembly_formation(category: GameState.NPCCategory, npc_count: int) -> void:
	# Verificar si ya existe un grupo para esta categoría
	var existing_groups = GameState.organized_groups.get(category, [])
	if not existing_groups.is_empty():
		print("Ya existe un grupo para %s" % GameState.get_category_name(category))
		return
	
	# Intentar formar el grupo
	if GameState.attempt_group_formation(category, global_position):
		_activate_assembly_visual_effects(category)
		_show_assembly_notification(category, npc_count)
		
		# Notificar actualización de grupos para UI
		GameState.update_groups_display()

func _activate_assembly_visual_effects(category: GameState.NPCCategory) -> void:
	# Cambiar color del área según la categoría
	if area_indicator:
		var material = area_indicator.get_surface_override_material(0)
		if material:
			var category_color = _get_category_color(category)
			material.albedo_color = Color(category_color.r, category_color.g, category_color.b, 0.6)
			
			# Efecto de pulso
			var tween = create_tween()
			tween.set_loops()
			tween.tween_property(material, "albedo_color:a", 0.3, 1.0)
			tween.tween_property(material, "albedo_color:a", 0.6, 1.0)

func _show_assembly_notification(category: GameState.NPCCategory, npc_count: int) -> void:
	# Crear notificación temporal
	var notification = Label3D.new()
	notification.text = "¡ASAMBLEA FORMADA!\n%s\n%d miembros" % [
		GameState.get_category_name(category),
		npc_count
	]
	notification.position = Vector3(0, 3, 0)
	notification.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	notification.font_size = 36
	notification.modulate = Color.YELLOW
	add_child(notification)
	
	# Animar y eliminar después de unos segundos
	var tween = create_tween()
	tween.parallel().tween_property(notification, "position:y", 5.0, 3.0)
	tween.parallel().tween_property(notification, "modulate:a", 0.0, 3.0)
	tween.tween_callback(notification.queue_free)
	
	print("¡ASAMBLEA FORMADA en %s! Categoría: %s, Miembros: %d" % [
		node_name,
		GameState.get_category_name(category),
		npc_count
	])

func _get_category_color(category: GameState.NPCCategory) -> Color:
	match category:
		GameState.NPCCategory.TRABAJO_PRECARIO:
			return Color.ORANGE
		GameState.NPCCategory.SIN_VIVIENDA:
			return Color.BROWN
		GameState.NPCCategory.SIN_SALUD:
			return Color.RED
		GameState.NPCCategory.SIN_EDUCACION:
			return Color.BLUE
		_:
			return Color.GRAY

## Información del nodo para UI
func get_node_info() -> Dictionary:
	return {
		"name": node_name,
		"type": node_type,
		"active": not players_in_area.is_empty(),
		"required_npcs": required_npcs
	}
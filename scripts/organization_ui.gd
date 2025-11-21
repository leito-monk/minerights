extends Control
## UI de Organización - Panel lateral que muestra el progreso de la organización comunitaria
##
## Muestra:
## - NPCs contactados por categoría
## - Grupos organizados 
## - Energía colectiva total
## - Progreso hacia derechos

# Referencias a elementos UI
@onready var npc_count_label: Label = $VBoxContainer/NPCSection/NPCCountLabel
@onready var energy_label: Label = $VBoxContainer/EnergySection/EnergyLabel
@onready var groups_container: VBoxContainer = $VBoxContainer/GroupsSection/GroupsContainer
@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressSection/SocialPressureBar
@onready var progress_label: Label = $VBoxContainer/ProgressSection/ProgressLabel

# Referencias a botones de acciones
@onready var actions_container: VBoxContainer = $VBoxContainer/ActionsSection/ActionsContainer
@onready var marcha_button: Button = null
@onready var asamblea_button: Button = null
@onready var huelga_button: Button = null
@onready var festival_button: Button = null

func _ready() -> void:
	print("UI de Organización inicializada")
	_setup_ui_elements()
	_connect_gamestate_signals()
	_create_action_buttons()
	_update_all_displays()

func _setup_ui_elements() -> void:
	# Configurar barra de progreso
	if progress_bar:
		progress_bar.min_value = 0
		progress_bar.max_value = 100
		progress_bar.value = 0

func _connect_gamestate_signals() -> void:
	# Conectar señales del GameState
	GameState.npc_contacted.connect(_on_npc_contacted)
	GameState.group_formed.connect(_on_group_formed)
	GameState.social_pressure_changed.connect(_on_social_pressure_changed)
	GameState.collective_action_performed.connect(_on_action_performed)
	GameState.right_conquered.connect(_on_right_conquered)

func _create_action_buttons() -> void:
	if not actions_container:
		return
	
	# Crear botones para cada acción
	marcha_button = _create_action_button("Marcha", GameState.ActionType.MARCHA)
	asamblea_button = _create_action_button("Asamblea", GameState.ActionType.ASAMBLEA)
	huelga_button = _create_action_button("Huelga", GameState.ActionType.HUELGA)
	festival_button = _create_action_button("Festival", GameState.ActionType.FESTIVAL)

func _create_action_button(text: String, action_type: GameState.ActionType) -> Button:
	var button = Button.new()
	button.text = text
	button.pressed.connect(_on_action_button_pressed.bind(action_type))
	actions_container.add_child(button)
	return button

func _on_action_button_pressed(action_type: GameState.ActionType) -> void:
	var success = GameState.perform_collective_action(action_type)
	if success:
		_show_action_feedback(GameState.get_action_name(action_type))
	else:
		_show_action_error(GameState.get_action_name(action_type))

func _show_action_feedback(action_name: String) -> void:
	print("¡%s ejecutada exitosamente!" % action_name)
	# TODO: Añadir efectos visuales/sonoros

func _show_action_error(action_name: String) -> void:
	print("No se puede ejecutar %s - Requisitos insuficientes" % action_name)
	# TODO: Mostrar tooltip con requisitos

func _update_all_displays() -> void:
	_update_npc_count()
	_update_energy_display()
	_update_groups_display()
	_update_progress_display()
	_update_action_buttons()

func _update_npc_count() -> void:
	if npc_count_label:
		var total = GameState.get_contacted_count()
		npc_count_label.text = "NPCs Contactados: %d" % total

func _update_energy_display() -> void:
	if energy_label:
		energy_label.text = "Energía Colectiva: %.0f" % GameState.collective_energy

func _update_groups_display() -> void:
	if not groups_container:
		return
	
	# Limpiar display anterior
	for child in groups_container.get_children():
		child.queue_free()
	
	# Mostrar grupos activos
	var groups_count = GameState.get_organized_groups_count()
	var groups_label = Label.new()
	groups_label.text = "Grupos Organizados: %d" % groups_count
	groups_container.add_child(groups_label)
	
	# Mostrar detalles de cada categoría
	for category in GameState.NPCCategory.values():
		var category_npcs = GameState.organized_groups.get(category, [])
		if not category_npcs.is_empty():
			var category_label = Label.new()
			category_label.text = "• %s: %d miembros" % [
				GameState.get_category_name(category),
				category_npcs.size()
			]
			category_label.modulate = Color.LIGHT_GREEN
			groups_container.add_child(category_label)

func _update_progress_display() -> void:
	if progress_bar:
		progress_bar.value = GameState.get_social_pressure_percentage()
	
	if progress_label:
		progress_label.text = "Presión Social: %.1f%%" % GameState.get_social_pressure_percentage()

func _update_action_buttons() -> void:
	var buttons = [
		{"button": marcha_button, "action": GameState.ActionType.MARCHA},
		{"button": asamblea_button, "action": GameState.ActionType.ASAMBLEA},
		{"button": huelga_button, "action": GameState.ActionType.HUELGA},
		{"button": festival_button, "action": GameState.ActionType.FESTIVAL}
	]
	
	for button_data in buttons:
		var button = button_data.button
		var action = button_data.action
		
		if button:
			var requirements = GameState.ACTION_COSTS.get(action, {})
			var required_groups = requirements.get("groups", 1)
			var required_energy = requirements.get("energy", 0.0)
			
			var can_perform = (
				GameState.get_organized_groups_count() >= required_groups and
				GameState.collective_energy >= required_energy
			)
			
			button.disabled = not can_perform
			
			# Actualizar tooltip con requisitos
			var tooltip = "%s\nRequisitos:\n• %d grupos\n• %.0f energía" % [
				GameState.get_action_name(action),
				required_groups,
				required_energy
			]
			button.tooltip_text = tooltip

# Callbacks de señales del GameState
func _on_npc_contacted(npc_data: Dictionary) -> void:
	_update_npc_count()
	_update_energy_display()
	_update_action_buttons()

func _on_group_formed(category_name: String, size: int) -> void:
	_update_groups_display()
	_update_action_buttons()
	
	# Mostrar notificación
	print("UI: Grupo formado - %s con %d miembros" % [category_name, size])

func _on_social_pressure_changed(new_value: float) -> void:
	_update_progress_display()

func _on_action_performed(action_name: String) -> void:
	_update_energy_display()
	_update_progress_display()
	_update_action_buttons()

func _on_right_conquered(right_name: String) -> void:
	_update_progress_display()
	
	# Mostrar celebración
	_show_right_conquered_celebration(right_name)

func _show_right_conquered_celebration(right_name: String) -> void:
	# Crear notificación de derecho conquistado
	var celebration_label = Label.new()
	celebration_label.text = "¡DERECHO CONQUISTADO!\n%s" % right_name
	celebration_label.add_theme_color_override("font_color", Color.GOLD)
	celebration_label.position = Vector2(200, 100)
	add_child(celebration_label)
	
	# Animar y eliminar
	var tween = create_tween()
	tween.parallel().tween_property(celebration_label, "position:y", 50, 3.0)
	tween.parallel().tween_property(celebration_label, "modulate:a", 0.0, 3.0)
	tween.tween_callback(celebration_label.queue_free)
	
	print("¡CELEBRACIÓN! Derecho conquistado: %s" % right_name)
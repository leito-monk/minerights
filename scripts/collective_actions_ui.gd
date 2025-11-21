extends Control

# UI para acciones colectivas
@onready var action_title = $VBoxContainer/ActionTitle
@onready var action_buttons = $VBoxContainer/ActionButtons
@onready var march_btn = $VBoxContainer/ActionButtons/MarchBtn
@onready var assembly_btn = $VBoxContainer/ActionButtons/AssemblyBtn
@onready var strike_btn = $VBoxContainer/ActionButtons/StrikeBtn
@onready var festival_btn = $VBoxContainer/ActionButtons/FestivalBtn

@onready var action_status = $VBoxContainer/ActionStatus
@onready var countdown_label = $VBoxContainer/CountdownLabel
@onready var participants_label = $VBoxContainer/ParticipantsLabel

var current_action = null
var action_timer = 0.0
var required_participants = 0

func _ready():
	# Conectar señales del GameState
	GameState.collective_action_started.connect(_on_action_started)
	GameState.collective_action_completed.connect(_on_action_completed)
	GameState.collective_action_failed.connect(_on_action_failed)
	GameState.groups_updated.connect(_update_button_states)
	
	# Conectar botones
	march_btn.pressed.connect(_on_march_pressed)
	assembly_btn.pressed.connect(_on_assembly_pressed)
	strike_btn.pressed.connect(_on_strike_pressed)
	festival_btn.pressed.connect(_on_festival_pressed)
	
	# Estado inicial
	_update_button_states()
	_hide_action_status()

func _process(delta):
	if current_action != null:
		action_timer -= delta
		countdown_label.text = "Tiempo restante: " + str(int(action_timer)) + "s"
		
		if action_timer <= 0:
			_complete_current_action()

func _update_button_states():
	var total_npcs = GameState.get_contacted_npcs_count()
	var total_groups = GameState.organized_groups.size()
	
	# Marcha: requiere al menos 5 NPCs contactados
	march_btn.disabled = total_npcs < 5
	march_btn.text = "Marcha (5+ contactos)" if total_npcs < 5 else "Marcha ✓"
	
	# Asamblea: requiere al menos 2 grupos
	assembly_btn.disabled = total_groups < 2
	assembly_btn.text = "Asamblea (2+ grupos)" if total_groups < 2 else "Asamblea ✓"
	
	# Huelga: requiere al menos 3 grupos y 15 NPCs
	strike_btn.disabled = total_groups < 3 or total_npcs < 15
	strike_btn.text = "Huelga (3+ grupos, 15+ contactos)" if (total_groups < 3 or total_npcs < 15) else "Huelga ✓"
	
	# Festival: requiere al menos 4 grupos y 20 NPCs
	festival_btn.disabled = total_groups < 4 or total_npcs < 20
	festival_btn.text = "Festival (4+ grupos, 20+ contactos)" if (total_groups < 4 or total_npcs < 20) else "Festival ✓"

func _on_march_pressed():
	GameState.start_collective_action("march", 15.0) # 15 segundos

func _on_assembly_pressed():
	GameState.start_collective_action("assembly", 30.0) # 30 segundos

func _on_strike_pressed():
	GameState.start_collective_action("strike", 45.0) # 45 segundos

func _on_festival_pressed():
	GameState.start_collective_action("festival", 60.0) # 60 segundos

func _on_action_started(action_type: String, duration: float):
	current_action = action_type
	action_timer = duration
	
	# Mostrar UI de acción activa
	_show_action_status()
	
	# Configurar según el tipo de acción
	match action_type:
		"march":
			action_title.text = "🚶 MARCHA EN PROGRESO"
			required_participants = 5
		"assembly":
			action_title.text = "🗣️ ASAMBLEA EN CURSO"
			required_participants = 8
		"strike":
			action_title.text = "✊ HUELGA ACTIVA"
			required_participants = 15
		"festival":
			action_title.text = "🎉 FESTIVAL COMUNITARIO"
			required_participants = 20
	
	# Deshabilitar botones durante acción
	_disable_all_buttons()
	
	_update_participants_count()

func _on_action_completed(action_type: String, energy_gained: int):
	current_action = null
	
	# Mostrar resultado exitoso
	action_title.text = "¡ACCIÓN COMPLETADA! +" + str(energy_gained) + " energía"
	action_status.text = "La acción fue un éxito. La comunidad se fortalece."
	countdown_label.text = ""
	
	# Efecto visual de celebración
	_show_celebration_effect()
	
	# Restaurar botones después de 3 segundos
	await get_tree().create_timer(3.0).timeout
	_hide_action_status()
	_update_button_states()

func _on_action_failed(action_type: String, reason: String):
	current_action = null
	
	# Mostrar resultado fallido
	action_title.text = "ACCIÓN FALLIDA"
	action_status.text = reason
	countdown_label.text = ""
	
	# Restaurar botones después de 3 segundos
	await get_tree().create_timer(3.0).timeout
	_hide_action_status()
	_update_button_states()

func _complete_current_action():
	if current_action:
		GameState.complete_collective_action(current_action)

func _update_participants_count():
	var contacted = GameState.get_contacted_npcs_count()
	participants_label.text = "Participantes: " + str(contacted) + "/" + str(required_participants)

func _show_action_status():
	action_status.visible = true
	countdown_label.visible = true
	participants_label.visible = true

func _hide_action_status():
	action_status.visible = false
	countdown_label.visible = false
	participants_label.visible = false

func _disable_all_buttons():
	march_btn.disabled = true
	assembly_btn.disabled = true
	strike_btn.disabled = true
	festival_btn.disabled = true

func _show_celebration_effect():
	# Efecto visual simple de celebración
	var tween = create_tween()
	tween.set_loops(3)
	tween.tween_property(self, "modulate", Color.YELLOW, 0.2)
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
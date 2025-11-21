extends Control

# UI para mostrar presión social y derechos conquistados
@onready var pressure_bar = $VBoxContainer/PressureContainer/PressureBar
@onready var pressure_label = $VBoxContainer/PressureContainer/PressureLabel
@onready var rights_list = $VBoxContainer/RightsList
@onready var current_right_label = $VBoxContainer/CurrentRightLabel
@onready var conquest_animation = $VBoxContainer/ConquestAnimation

var rights_names = {
	"Derecho a la Salud": "🏥 Salud",
	"Derecho a la Educación": "📚 Educación", 
	"Derecho a la Vivienda": "🏠 Vivienda",
	"Derecho al Trabajo Digno": "⚒️ Trabajo Digno"
}

func _ready():
	# Conectar señales del GameState
	GameState.social_pressure_changed.connect(_on_pressure_changed)
	GameState.right_conquered.connect(_on_right_conquered)
	
	# Inicializar UI
	_update_pressure_display()
	_update_rights_display()
	_update_current_target()
	
	conquest_animation.visible = false

func _on_pressure_changed(new_pressure: float):
	_update_pressure_display()
	
	# Efecto visual cuando se acerca al 100%
	if new_pressure > 80:
		_animate_critical_pressure()

func _on_right_conquered(right_name: String):
	_show_conquest_celebration(right_name)
	_update_rights_display()
	_update_current_target()
	_update_pressure_display()

func _update_pressure_display():
	var pressure = GameState.social_pressure
	var percentage = GameState.get_social_pressure_percentage()
	
	pressure_bar.value = percentage
	pressure_label.text = "Presión Social: " + str(int(percentage)) + "%"
	
	# Cambiar color según el nivel
	if percentage < 30:
		pressure_bar.modulate = Color.GRAY
	elif percentage < 70:
		pressure_bar.modulate = Color.YELLOW
	else:
		pressure_bar.modulate = Color.RED

func _update_rights_display():
	# Limpiar lista actual
	for child in rights_list.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	# Mostrar derechos conquistados
	for right_name in GameState.conquered_rights:
		var right_label = Label.new()
		var display_name = _get_right_display_name(GameState.get_right_name(right_name))
		right_label.text = "✓ " + display_name
		right_label.modulate = Color.GREEN
		rights_list.add_child(right_label)

func _update_current_target():
	var conquered_count = GameState.get_conquered_rights_count()
	
	if conquered_count >= 4:
		current_right_label.text = "🎉 ¡TODOS LOS DERECHOS CONQUISTADOS!"
		current_right_label.modulate = Color.GOLD
	else:
		var next_rights = []
		for right_type in GameState.RightType.values():
			if right_type not in GameState.conquered_rights:
				next_rights.append(GameState.get_right_name(right_type))
		
		if next_rights.size() > 0:
			var display_name = _get_right_display_name(next_rights[0])
			current_right_label.text = "Objetivo actual: " + display_name
			current_right_label.modulate = Color.WHITE

func _get_right_display_name(right_name: String) -> String:
	return rights_names.get(right_name, right_name)

func _animate_critical_pressure():
	var tween = create_tween()
	tween.set_loops(2)
	tween.tween_property(pressure_bar, "modulate", Color.WHITE, 0.3)
	tween.tween_property(pressure_bar, "modulate", Color.RED, 0.3)

func _show_conquest_celebration(right_name: String):
	conquest_animation.visible = true
	conquest_animation.text = "¡DERECHO CONQUISTADO!\n" + _get_right_display_name(right_name)
	
	# Animación de celebración
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Efecto de aparición
	conquest_animation.modulate.a = 0.0
	conquest_animation.scale = Vector2(0.5, 0.5)
	
	tween.tween_property(conquest_animation, "modulate:a", 1.0, 0.5)
	tween.tween_property(conquest_animation, "scale", Vector2(1.2, 1.2), 0.5)
	tween.tween_delay(2.0)
	tween.tween_property(conquest_animation, "modulate:a", 0.0, 0.5)
	
	await tween.finished
	conquest_animation.visible = false
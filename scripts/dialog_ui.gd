extends Control
## UI del sistema de diálogo.
##
## Muestra el nombre y mensaje del NPC cuando el jugador interactúa.
## Se puede cerrar presionando la tecla E nuevamente o haciendo clic en cerrar.

# Referencias a los elementos de UI
@onready var panel: Panel = $Panel
@onready var name_label: Label = $Panel/VBoxContainer/NameLabel
@onready var message_label: Label = $Panel/VBoxContainer/MessageLabel
@onready var close_button: Button = $Panel/VBoxContainer/CloseButton


func _ready() -> void:
	# Conectar señal del botón de cerrar
	if close_button:
		close_button.pressed.connect(_on_close_button_pressed)
	
	# Ocultar al inicio
	visible = false


func _input(event: InputEvent) -> void:
	# Permitir cerrar el diálogo con la tecla E
	if visible and event.is_action_pressed("interact"):
		hide_dialog()


## Muestra el diálogo con el nombre y mensaje del NPC
func show_dialog(npc_name: String, npc_message: String) -> void:
	if name_label:
		name_label.text = npc_name
	
	if message_label:
		message_label.text = npc_message
	
	visible = true
	
	# Pausar el juego mientras se muestra el diálogo (opcional)
	# get_tree().paused = true


## Oculta el diálogo
func hide_dialog() -> void:
	visible = false
	
	# Reanudar el juego
	# get_tree().paused = false


## Callback del botón de cerrar
func _on_close_button_pressed() -> void:
	hide_dialog()

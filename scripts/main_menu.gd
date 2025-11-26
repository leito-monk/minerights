extends Control
## Menú principal del juego MineRights
##
## Maneja la navegación inicial, muestra instrucciones y permite 
## acceder a diferentes módulos del juego.

# Referencia al GameManager para obtener progreso
var game_manager: Node = null

# Señales para comunicación con el sistema principal
signal start_game_requested
signal activities_requested

@onready var progress_label: Label = $VBoxContainer/ProgressLabel
@onready var start_button: Button = $VBoxContainer/ButtonsContainer/StartButton
@onready var activities_button: Button = $VBoxContainer/ButtonsContainer/ActivitiesButton


func _ready() -> void:
	# Actualizar progreso si hay GameManager disponible
	update_progress_display()


## Actualiza la visualización del progreso del juego
func update_progress_display() -> void:
	if game_manager and progress_label:
		var contacted = game_manager.contacted_npcs.size() if game_manager.has_method("get_contacted_npcs") else 0
		var total = game_manager.total_npcs if game_manager.has_method("get_total_npcs") else 5
		progress_label.text = "Progreso: %d/%d NPCs contactados" % [contacted, total]
		
		# Cambiar color según progreso
		if contacted >= total:
			progress_label.add_theme_color_override("font_color", Color.GREEN)
		else:
			progress_label.add_theme_color_override("font_color", Color.WHITE)


## Método llamado cuando se presiona el botón de comenzar juego
func _on_start_button_pressed() -> void:
	print("Iniciando juego...")
	emit_signal("start_game_requested")
	visible = false


## Método llamado cuando se presiona el botón de actividades
func _on_activities_button_pressed() -> void:
	print("Abriendo módulo de actividades...")
	emit_signal("activities_requested")
	# Aquí se podría abrir un menú de actividades o mini-juegos


## Método para mostrar el menú (llamado desde GameManager)
func show_menu() -> void:
	visible = true
	update_progress_display()


## Método para ocultar el menú
func hide_menu() -> void:
	visible = false


## Conectar con el GameManager para sincronizar progreso
func connect_game_manager(gm: Node) -> void:
	game_manager = gm
	update_progress_display()
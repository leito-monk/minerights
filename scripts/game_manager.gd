extends Node
## Gestor principal del juego.
##
## Coordina la interacción entre el jugador, los NPCs y el sistema de UI.
## Mantiene un registro de los NPCs contactados y gestiona el flujo del diálogo.
## Maneja el menú principal y las actividades organizadas.

# Referencias a nodos importantes
@onready var player: CharacterBody3D = $"../Player"
@onready var dialog_ui: Control = $"../UI/DialogUI"
@onready var instructions_ui: Control = $"../UI/InstructionsUI"
@onready var main_menu: Control = $"../UI/MainMenu"
@onready var activities_menu: Control = $"../UI/ActivitiesMenu"

# Lista de NPCs contactados
var contacted_npcs: Array[String] = []

# Total de NPCs en el juego
var total_npcs: int = 5

# Estado del juego
var game_started: bool = false


func _ready() -> void:
	# Conectar señal del jugador
	if player:
		player.interacted_with_npc.connect(_on_player_interacted_with_npc)
	
	# Conectar señales del menú principal
	if main_menu:
		main_menu.start_game_requested.connect(_on_start_game_requested)
		main_menu.activities_requested.connect(_on_activities_requested)
		main_menu.connect_game_manager(self)
	
	# Conectar señales del menú de actividades
	if activities_menu:
		activities_menu.activity_organized.connect(_on_activity_organized)
	
	# Configurar UI inicial
	setup_initial_ui()


## Configura la UI inicial del juego
func setup_initial_ui() -> void:
	# Mostrar menú principal al inicio
	if main_menu:
		main_menu.show_menu()
	
	# Ocultar otros elementos de UI
	if dialog_ui:
		dialog_ui.visible = false
	
	if instructions_ui:
		instructions_ui.visible = false
	
	if activities_menu:
		activities_menu.visible = false
	
	# Desactivar player al inicio
	if player:
		player.process_mode = Node.PROCESS_MODE_DISABLED
	
	print("Juego iniciado: %d NPCs disponibles" % total_npcs)


## Maneja la interacción del jugador con un NPC
func _on_player_interacted_with_npc(npc: Node3D) -> void:
	if not npc or not npc.has_method("get_dialog_data"):
		push_warning("Intento de interacción con NPC inválido")
		return
	
	# Obtener datos del diálogo
	var dialog_data = npc.get_dialog_data()
	
	# Marcar NPC como contactado si es la primera vez
	if not npc.is_contacted():
		npc.mark_as_contacted()
		_register_contacted_npc(dialog_data.name)
	
	# Mostrar diálogo
	if dialog_ui:
		dialog_ui.show_dialog(dialog_data.name, dialog_data.message)


## Registra un NPC como contactado
func _register_contacted_npc(npc_name: String) -> void:
	if npc_name not in contacted_npcs:
		contacted_npcs.append(npc_name)
		print("NPC contactado: %s (%d/%d)" % [npc_name, contacted_npcs.size(), total_npcs])
		
		# Actualizar UI de progreso
		if instructions_ui:
			instructions_ui.update_progress(contacted_npcs.size(), total_npcs)
		
		if main_menu and main_menu.has_method("update_progress_display"):
			main_menu.update_progress_display()
		
		# Verificar si se contactaron todos los NPCs
		if contacted_npcs.size() >= total_npcs:
			_on_all_npcs_contacted()


## Llamado cuando todos los NPCs han sido contactados
func _on_all_npcs_contacted() -> void:
	print("¡Felicitaciones! Has hablado con todos los NPCs.")
	# Aquí se podría mostrar un mensaje de victoria o desbloquear contenido adicional


## Retorna la lista de NPCs contactados
func get_contacted_npcs() -> Array[String]:
	return contacted_npcs.duplicate()


## Retorna el progreso del jugador
func get_progress() -> Dictionary:
	return {
		"contacted": contacted_npcs.size(),
		"total": total_npcs,
		"percentage": (float(contacted_npcs.size()) / float(total_npcs)) * 100.0
	}


## Método llamado cuando se solicita iniciar el juego
func _on_start_game_requested() -> void:
	print("Iniciando juego desde menú principal...")
	start_game()


## Método llamado cuando se solicita abrir actividades
func _on_activities_requested() -> void:
	print("Abriendo menú de actividades...")
	if activities_menu:
		activities_menu.show_menu()


## Método llamado cuando se organiza una actividad
func _on_activity_organized(activity_type: String) -> void:
	print("Actividad organizada en GameManager: ", activity_type)
	# Aquí podrías agregar lógica adicional como rewards, progreso especial, etc.


## Inicia el gameplay principal
func start_game() -> void:
	game_started = true
	
	# Ocultar menú principal
	if main_menu:
		main_menu.hide_menu()
	
	# Mostrar instrucciones
	if instructions_ui:
		instructions_ui.visible = true
	
	# Activar el player
	if player:
		player.process_mode = Node.PROCESS_MODE_INHERIT
	
	print("Juego iniciado - El jugador puede moverse e interactuar")


## Pausa el juego y vuelve al menú principal
func return_to_main_menu() -> void:
	game_started = false
	
	# Desactivar player
	if player:
		player.process_mode = Node.PROCESS_MODE_DISABLED
	
	# Ocultar UI de juego
	if instructions_ui:
		instructions_ui.visible = false
	
	if dialog_ui:
		dialog_ui.visible = false
	
	# Mostrar menú principal
	if main_menu:
		main_menu.show_menu()


## Getter para total de NPCs (usado por menú)
func get_total_npcs() -> int:
	return total_npcs

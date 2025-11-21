extends Node
## Gestor principal del juego.
##
## Coordina la interacción entre el jugador, los NPCs y el sistema de UI.
## Mantiene un registro de los NPCs contactados y gestiona el flujo del diálogo.

# Referencias a nodos importantes
@onready var player: CharacterBody3D = $"../Player"
@onready var dialog_ui: Control = $"../UI/DialogUI"
@onready var instructions_ui: Control = $"../UI/InstructionsUI"

# Lista de NPCs contactados
var contacted_npcs: Array[String] = []

# Total de NPCs en el juego
var total_npcs: int = 5


func _ready() -> void:
	# Conectar señal del jugador
	if player:
		player.interacted_with_npc.connect(_on_player_interacted_with_npc)
	
	# Ocultar el diálogo al inicio
	if dialog_ui:
		dialog_ui.visible = false
	
	# Mostrar instrucciones al inicio
	if instructions_ui:
		instructions_ui.visible = true
	
	print("Juego iniciado: %d NPCs disponibles" % total_npcs)


## Maneja la interacción del jugador con un NPC
func _on_player_interacted_with_npc(npc: Node3D) -> void:
	if not npc or not npc.has_method("get_dialog_data"):
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

extends Node3D

# Game Manager simple para escena de prueba

var player: CharacterBody3D = null
var dialog_ui: Control = null

func _ready() -> void:
	print("GameManager Test: Iniciando...")
	
	# Buscar referencias
	player = get_node_or_null("Player")
	dialog_ui = get_node_or_null("UI/DialogUI")
	
	if player:
		print("Jugador encontrado")
		if not player.interacted_with_npc.is_connected(_on_player_interacted_with_npc):
			player.interacted_with_npc.connect(_on_player_interacted_with_npc)
			print("Señal del jugador conectada")
	else:
		print("ERROR: Jugador no encontrado")
		
	if dialog_ui:
		print("Dialog UI encontrado")
	else:
		print("ERROR: Dialog UI no encontrado")
	
	print("GameManager Test: Listo!")

func _on_player_interacted_with_npc(npc: Node3D) -> void:
	print("GameManager: Interacción con NPC - ", npc.npc_name)
	
	if dialog_ui and dialog_ui.has_method("show_dialog"):
		var dialog_data = {
			"npc_name": npc.npc_name,
			"message": npc.npc_message
		}
		dialog_ui.show_dialog(dialog_data)
		
		# Marcar NPC como contactado
		if npc.has_method("mark_as_contacted"):
			npc.mark_as_contacted()
			print("NPC marcado como contactado")
	else:
		print("ERROR: No se puede mostrar diálogo")
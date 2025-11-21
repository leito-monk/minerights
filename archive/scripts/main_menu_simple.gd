extends Control

# Pantalla principal del juego - versión simplificada para debug

	var main_scene_path = "res://scenes/simple_game.tscn"func _ready():
	print("MainMenu: Iniciando...")
	
	# Conectar botones de manera segura
	var start_button = get_node_or_null("VBoxContainer/ButtonContainer/StartButton")
	var credits_button = get_node_or_null("VBoxContainer/ButtonContainer/CreditsButton") 
	var quit_button = get_node_or_null("VBoxContainer/ButtonContainer/QuitButton")
	
	if start_button:
		start_button.pressed.connect(_on_start_pressed)
		print("MainMenu: StartButton conectado")
	else:
		print("ERROR: StartButton no encontrado")
		
	if credits_button:
		credits_button.pressed.connect(_on_credits_pressed)
		print("MainMenu: CreditsButton conectado")
	else:
		print("ERROR: CreditsButton no encontrado")
		
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)
		print("MainMenu: QuitButton conectado")
	else:
		print("ERROR: QuitButton no encontrado")
	
	print("MainMenu: Inicialización completa")

func _on_start_pressed():
	print("MainMenu: Iniciando juego...")
	get_tree().change_scene_to_file(main_scene_path)

func _on_credits_pressed():
	print("MainMenu: Mostrando créditos...")
	_show_credits_popup()

func _on_quit_pressed():
	print("MainMenu: Saliendo del juego...")
	get_tree().quit()

func _show_credits_popup():
	var popup = AcceptDialog.new()
	popup.title = "Créditos"
	popup.dialog_text = """MineRights - Juego de Organización Comunitaria

Desarrollado para concientizar sobre:
- La importancia de la organización colectiva
- Los derechos sociales fundamentales
- La construcción de movimientos populares

Hecho con Godot 4.x y mucho ❤️

¡La lucha por los derechos es colectiva!"""
	
	add_child(popup)
	popup.popup_centered()
	popup.confirmed.connect(popup.queue_free)
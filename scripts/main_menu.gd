extends Control

# Pantalla principal del juego con explicación de mecánicas

var title_label: Label
var subtitle_label: Label  
var mechanics_container: VBoxContainer
var start_button: Button
var credits_button: Button
var quit_button: Button

var main_scene_path = "res://scenes/main_fixed.tscn"

func _ready():
	print("MainMenu: Inicializando menú principal...")
	
	# Obtener referencias a nodos
	title_label = get_node("VBoxContainer/TitleContainer/GameTitle")
	subtitle_label = get_node("VBoxContainer/TitleContainer/Subtitle")
	mechanics_container = get_node("VBoxContainer/MechanicsContainer")
	start_button = get_node("VBoxContainer/ButtonContainer/StartButton")
	credits_button = get_node("VBoxContainer/ButtonContainer/CreditsButton")
	quit_button = get_node("VBoxContainer/ButtonContainer/QuitButton")
	
	print("MainMenu: Nodos encontrados - Start:", start_button != null, " Credits:", credits_button != null, " Quit:", quit_button != null)
	
	# Configurar botones
	if start_button:
		start_button.pressed.connect(_on_start_pressed)
		print("MainMenu: Botón Start conectado")
	
	if credits_button:
		credits_button.pressed.connect(_on_credits_pressed)
		print("MainMenu: Botón Credits conectado")
	
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)
		print("MainMenu: Botón Quit conectado")
	
	# Animación de entrada
	_animate_entrance()
	
	print("MainMenu: Inicialización completa")

func _animate_entrance():
	# Comenzar con elementos invisibles
	modulate.a = 0.0
	scale = Vector2(0.8, 0.8)
	
	# Animación de fade in y scale
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 1.0)

func _on_start_pressed():
	# Transición suave al juego principal
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	get_tree().change_scene_to_file(main_scene_path)

func _on_credits_pressed():
	# Mostrar créditos (implementar después si es necesario)
	_show_credits_popup()

func _on_quit_pressed():
	get_tree().quit()

func _show_credits_popup():
	# Crear popup de créditos simple
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
	
	# Eliminar popup después de cerrarlo
	popup.confirmed.connect(popup.queue_free)
extends Control

# Pantalla de presentación mejorada con animaciones y diseño atractivo

@onready var title_container = $BackgroundLayer/VBoxContainer/TitleContainer
@onready var game_title = $BackgroundLayer/VBoxContainer/TitleContainer/TitleVBox/GameTitle
@onready var subtitle = $BackgroundLayer/VBoxContainer/TitleContainer/TitleVBox/Subtitle
@onready var mechanics_panel = $BackgroundLayer/VBoxContainer/MechanicsPanel
@onready var start_button = $BackgroundLayer/VBoxContainer/ButtonContainer/StartButton
@onready var credits_button = $BackgroundLayer/VBoxContainer/ButtonContainer/SecondaryButtons/CreditsButton
@onready var quit_button = $BackgroundLayer/VBoxContainer/ButtonContainer/SecondaryButtons/QuitButton
@onready var particles = $ParticleLayer/Particles

var main_scene_path = "res://scenes/main_fixed.tscn"
var tween: Tween

func _ready():
	print("MainMenu Enhanced: Inicializando...")
	
	# Verificar que todos los nodos existan
	_verify_nodes()
	
	# Configurar botones
	if start_button:
		start_button.pressed.connect(_on_start_pressed)
		print("StartButton conectado")
	else:
		print("ERROR: StartButton no encontrado")
	
	if credits_button:
		credits_button.pressed.connect(_on_credits_pressed)
		print("CreditsButton conectado")
	else:
		print("ERROR: CreditsButton no encontrado")
	
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)
		print("QuitButton conectado")
	else:
		print("ERROR: QuitButton no encontrado")
	
	# Iniciar animaciones de entrada
	_animate_entrance()
	
	print("MainMenu Enhanced: Listo!")

func _verify_nodes():
	print("Verificando nodos...")
	print("title_container:", title_container != null)
	print("game_title:", game_title != null)
	print("mechanics_panel:", mechanics_panel != null)
	print("start_button:", start_button != null)
	print("credits_button:", credits_button != null)
	print("quit_button:", quit_button != null)

func _animate_entrance():
	# Asegurar que todos los elementos sean visibles primero
	if title_container:
		title_container.modulate.a = 1.0
	if mechanics_panel:
		mechanics_panel.modulate.a = 1.0
	if start_button and start_button.get_parent():
		start_button.get_parent().modulate.a = 1.0
	
	# Solo hacer animación simple de escalado si los nodos existen
	if game_title:
		game_title.scale = Vector2(0.8, 0.8)
		tween = create_tween()
		tween.tween_property(game_title, "scale", Vector2(1.0, 1.0), 0.5)
		await tween.finished
		_start_title_breathing()
	
	print("Animación de entrada completada")

func _start_title_breathing():
	if game_title:
		var breath_tween = create_tween()
		breath_tween.set_loops()
		breath_tween.tween_property(game_title, "scale", Vector2(1.05, 1.05), 2.0)
		breath_tween.tween_property(game_title, "scale", Vector2(1.0, 1.0), 2.0)

func _on_start_pressed():
	print("Iniciando juego principal...")
	
	# Animación de salida
	var exit_tween = create_tween()
	exit_tween.set_parallel(true)
	exit_tween.tween_property(self, "modulate:a", 0.0, 0.5)
	exit_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.5)
	
	await exit_tween.finished
	get_tree().change_scene_to_file(main_scene_path)

func _on_credits_pressed():
	print("Mostrando créditos...")
	_show_enhanced_credits()

func _on_quit_pressed():
	print("Saliendo del juego...")
	
	# Animación de salida
	var quit_tween = create_tween()
	quit_tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await quit_tween.finished
	
	get_tree().quit()

func _show_enhanced_credits():
	var credits_popup = AcceptDialog.new()
	credits_popup.title = "🎮 MINERIGHTS - Créditos"
	credits_popup.dialog_text = """🏠 MINERIGHTS ⚒️
Juego de Organización Comunitaria

🎯 OBJETIVO PEDAGÓGICO:
• Concientizar sobre la importancia de la organización colectiva
• Visibilizar problemáticas sociales reales
• Enseñar estrategias de construcción de movimientos
• Celebrar la conquista de derechos fundamentales

🛠️ DESARROLLO:
• Motor: Godot 4.x
• Lenguaje: GDScript
• Arquitectura: Sistemas modulares con singleton pattern

❤️ INSPIRACIÓN:
La lucha por los derechos es colectiva.
Cada victoria es de toda la comunidad.

¡Gracias por jugar y organizarte! ✊"""
	
	# Estilo mejorado
	credits_popup.min_size = Vector2(500, 400)
	
	add_child(credits_popup)
	credits_popup.popup_centered()
	
	# Eliminar popup cuando se cierre
	credits_popup.confirmed.connect(credits_popup.queue_free)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_quit_pressed()
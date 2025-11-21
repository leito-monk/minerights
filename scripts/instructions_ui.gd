extends Control
## UI de instrucciones y progreso.
##
## Muestra instrucciones básicas de control y el progreso
## de NPCs contactados.

# Referencias a elementos de UI
@onready var instructions_label: Label = $Panel/VBoxContainer/InstructionsLabel
@onready var progress_label: Label = $Panel/VBoxContainer/ProgressLabel


func _ready() -> void:
	# Configurar texto de instrucciones
	if instructions_label:
		instructions_label.text = "CONTROLES:\nWASD - Movimiento\nE - Interactuar con NPCs\n\nOBJETIVO:\nHabla con todos los NPCs para aprender sobre derechos humanos"
	
	# Inicializar progreso
	update_progress(0, 5)


## Actualiza la visualización del progreso
func update_progress(contacted: int, total: int) -> void:
	if progress_label:
		progress_label.text = "NPCs contactados: %d/%d" % [contacted, total]
		
		# Cambiar color del texto según progreso
		if contacted >= total:
			progress_label.add_theme_color_override("font_color", Color.GREEN)
		else:
			progress_label.add_theme_color_override("font_color", Color.WHITE)

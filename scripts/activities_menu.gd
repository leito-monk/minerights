extends Control
## Menú para organizar actividades educativas sobre derechos humanos
##
## Permite al usuario organizar diferentes tipos de eventos educativos
## basados en los temas de derechos humanos del juego.

signal activity_organized(activity_type: String)

# Diccionario con información de actividades
var activities_info = {
	"educacion": {
		"name": "Taller sobre Derecho a la Educación",
		"description": "Organiza un taller interactivo para enseñar sobre el derecho fundamental a la educación",
		"participants": "Estudiantes, padres y educadores"
	},
	"salud": {
		"name": "Charla sobre Derecho a la Salud", 
		"description": "Coordina una charla informativa sobre el acceso universal a la salud",
		"participants": "Comunidad general y profesionales de salud"
	},
	"trabajo": {
		"name": "Mesa Redonda sobre Derechos Laborales",
		"description": "Organiza un debate sobre condiciones laborales justas y derechos de trabajadores",
		"participants": "Trabajadores, sindicalistas y empleadores"
	},
	"vivienda": {
		"name": "Foro sobre Derecho a la Vivienda",
		"description": "Planifica un foro comunitario sobre vivienda digna y accesible",
		"participants": "Familias, arquitectos y funcionarios públicos"
	},
	"libertad": {
		"name": "Debate sobre Libertad de Expresión",
		"description": "Facilita un debate abierto sobre libertad de expresión y democracia",
		"participants": "Ciudadanos, periodistas y activistas"
	}
}

# Lista de actividades organizadas
var organized_activities: Array[String] = []


func _ready() -> void:
	print("Menú de actividades inicializado")


## Método llamado cuando se organiza una actividad
func _on_organize_activity(activity_type: String) -> void:
	if activity_type in activities_info:
		var activity = activities_info[activity_type]
		
		# Agregar a la lista de organizadas si no está ya
		if activity_type not in organized_activities:
			organized_activities.append(activity_type)
		
		# Mostrar mensaje de confirmación
		show_activity_confirmation(activity)
		
		# Emitir señal
		emit_signal("activity_organized", activity_type)
		
		print("Actividad organizada: ", activity["name"])


## Muestra confirmación de actividad organizada
func show_activity_confirmation(activity: Dictionary) -> void:
	# Aquí podrías mostrar un popup de confirmación
	var message = "¡Actividad organizada exitosamente!\n\n"
	message += activity["name"] + "\n\n"
	message += activity["description"] + "\n\n"
	message += "Participantes: " + activity["participants"]
	
	# Por ahora solo print, pero podrías crear un AcceptDialog
	print("=== ACTIVIDAD ORGANIZADA ===")
	print(message)
	print("============================")


## Método llamado cuando se cierra el menú
func _on_close_button_pressed() -> void:
	visible = false


## Método para mostrar el menú
func show_menu() -> void:
	visible = true


## Método para ocultar el menú
func hide_menu() -> void:
	visible = false


## Obtener lista de actividades organizadas
func get_organized_activities() -> Array[String]:
	return organized_activities


## Verificar si una actividad específica ha sido organizada
func is_activity_organized(activity_type: String) -> bool:
	return activity_type in organized_activities
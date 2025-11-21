extends Node3D
## Script para NPCs interactuables.
##
## Cada NPC tiene un nombre, mensaje sobre derechos humanos,
## y puede ser marcado como contactado cuando el jugador interactúa.

# Propiedades exportadas para configurar desde el editor
@export var npc_name: String = "NPC"
@export_multiline var npc_message: String = "Mensaje sobre derechos humanos"
@export var npc_color: Color = Color.WHITE

# Estado del NPC
var has_been_contacted: bool = false


func _ready() -> void:
	# Aplicar el color al material del cubo
	var mesh_instance = get_node_or_null("MeshInstance3D")
	if mesh_instance:
		var material = StandardMaterial3D.new()
		material.albedo_color = npc_color
		# Estética low-poly: sin suavizado de iluminación
		# UNSHADED mantiene colores puros y refuerza el estilo low-poly simple
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mesh_instance.set_surface_override_material(0, material)
	
	# Actualizar el label con el nombre del NPC
	var label = get_node_or_null("Label3D")
	if label:
		label.text = npc_name


## Retorna los datos del NPC para mostrar en el diálogo
func get_dialog_data() -> Dictionary:
	return {
		"name": npc_name,
		"message": npc_message
	}


## Marca el NPC como contactado
func mark_as_contacted() -> void:
	has_been_contacted = true
	# Podemos cambiar visualmente el NPC para indicar que ya fue contactado
	# Por ejemplo, hacer el color un poco más brillante
	var mesh_instance = get_node_or_null("MeshInstance3D")
	if mesh_instance and mesh_instance.get_surface_override_material(0):
		var material = mesh_instance.get_surface_override_material(0)
		if material is StandardMaterial3D:
			material.emission_enabled = true
			material.emission = npc_color * 0.3


## Verifica si el NPC ya fue contactado
func is_contacted() -> bool:
	return has_been_contacted

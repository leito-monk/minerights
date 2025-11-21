extends Node
## GameState - Sistema de gestión de estado global del juego MineRights
##
## Maneja todos los datos persistentes del juego incluyendo:
## - NPCs contactados y sus categorías
## - Grupos organizados por categoría
## - Derechos conquistados y progreso
## - Presión social y energía colectiva

# Señales para comunicación entre sistemas
signal npc_contacted(npc_data: Dictionary)
signal group_formed(category: String, size: int)
signal collective_action_performed(action_type: String)
signal right_conquered(right_name: String)
signal social_pressure_changed(new_value: float)
signal collective_action_started(action_type: String, duration: float)
signal collective_action_completed(action_type: String, energy_gained: int)
signal collective_action_failed(action_type: String, reason: String)
signal groups_updated()

# Enums para categorías y tipos de acciones
enum NPCCategory {
	TRABAJO_PRECARIO,
	SIN_VIVIENDA, 
	SIN_SALUD,
	SIN_EDUCACION
}

enum ActionType {
	MARCHA,
	ASAMBLEA,
	HUELGA,
	FESTIVAL
}

enum RightType {
	SALUD,
	EDUCACION,
	VIVIENDA,
	TRABAJO_DIGNO
}

# Estado del juego
var contacted_npcs: Array[Dictionary] = []
var organized_groups: Dictionary = {} # {categoria: [array_de_npcs]}
var conquered_rights: Array[RightType] = []
var social_pressure: float = 0.0
var collective_energy: float = 0.0

# Base de datos de NPCs con diálogos
var npc_dialogs: Dictionary = {}

# Configuración de gameplay
const MIN_NPCS_FOR_GROUP: int = 3
const MAX_SOCIAL_PRESSURE: float = 100.0
const ENERGY_PER_NPC: float = 10.0
const PRESSURE_PER_ACTION: Dictionary = {
	ActionType.MARCHA: 15.0,
	ActionType.ASAMBLEA: 10.0,
	ActionType.HUELGA: 25.0,
	ActionType.FESTIVAL: 5.0
}

# Costos de acciones en energía
const ACTION_COSTS: Dictionary = {
	ActionType.MARCHA: {"groups": 2, "energy": 50.0},
	ActionType.ASAMBLEA: {"groups": 1, "energy": 30.0},
	ActionType.HUELGA: {"groups": 3, "energy": 80.0},
	ActionType.FESTIVAL: {"groups": 1, "energy": 20.0}
}

func _ready() -> void:
	print("GameState: Iniciando sistema de estado global...")
	_initialize_groups()
	_initialize_dialogs()
	print("GameState: Sistema inicializado correctamente")

func _initialize_dialogs() -> void:
	npc_dialogs = {
		"María Trabajadora": {
			"category": NPCCategory.TRABAJO_PRECARIO,
			"dialog": [
				"¡Hola! Soy María. Trabajo en una fábrica pero mi salario no alcanza para vivir dignamente.",
				"Necesitamos organizarnos para conseguir mejores condiciones laborales.",
				"¿Te unes a nuestra causa por el trabajo digno?"
			],
			"responses": [
				"Sí, me uno a la lucha por el trabajo digno",
				"Cuéntame más sobre tu situación",
				"Tal vez en otro momento"
			]
		},
		"Carlos Obrero": {
			"category": NPCCategory.TRABAJO_PRECARIO,
			"dialog": [
				"Soy Carlos, obrero de la construcción. Mi jefe no respeta nuestros derechos.",
				"Trabajamos sin seguridad y nos pagan cuando quiere.",
				"¡Hay que hacer algo para cambiar esto!"
			],
			"responses": [
				"Tienes razón, organizémonos",
				"¿Qué propones hacer?",
				"Es complicado..."
			]
		},
		"Ana Empleada": {
			"category": NPCCategory.TRABAJO_PRECARIO,
			"dialog": [
				"Hola, soy Ana. Trabajo en un supermercado con turnos de 12 horas.",
				"No tengo vacaciones ni descansos adecuados.",
				"Los trabajadores merecemos dignidad."
			],
			"responses": [
				"Absolutamente, luchemos juntos",
				"¿Has intentado organizarte?",
				"Qué difícil situación"
			]
		},
		"Pedro Jornalero": {
			"category": NPCCategory.TRABAJO_PRECARIO,
			"dialog": [
				"Soy Pedro, trabajo por días en lo que salga.",
				"Sin contrato, sin derechos, sin estabilidad.",
				"Necesitamos trabajo digno para todos."
			],
			"responses": [
				"Me uno a ti",
				"¿Cómo podemos cambiar esto?",
				"Entiendo tu frustración"
			]
		},
		"Juan Sin Hogar": {
			"category": NPCCategory.SIN_VIVIENDA,
			"dialog": [
				"Soy Juan. Perdí mi casa hace meses y vivo en la calle.",
				"La vivienda es un derecho, no un privilegio.",
				"Necesitamos que el gobierno garantice techo para todos."
			],
			"responses": [
				"La vivienda es un derecho humano",
				"¿Cómo llegaste a esta situación?",
				"Debe ser muy duro"
			]
		},
		"Laura Inquilina": {
			"category": NPCCategory.SIN_VIVIENDA,
			"dialog": [
				"Hola, soy Laura. Mi casero me sube el alquiler cada mes.",
				"Ya no puedo pagarlo pero no tengo dónde ir.",
				"Los inquilinos necesitamos protección legal."
			],
			"responses": [
				"Organicémonos para cambiar las leyes",
				"¿Has buscado ayuda legal?",
				"Qué injusto"
			]
		},
		"Roberto Desahuciado": {
			"category": NPCCategory.SIN_VIVIENDA,
			"dialog": [
				"Soy Roberto. El banco me quitó la casa por no poder pagar.",
				"Trabajé 20 años para comprarla y la perdí por la crisis.",
				"Nadie debería quedarse sin hogar."
			],
			"responses": [
				"Luchemos contra los desahucios",
				"El sistema es injusto",
				"Lo lamento mucho"
			]
		},
		"Sofia Madre": {
			"category": NPCCategory.SIN_VIVIENDA,
			"dialog": [
				"Soy Sofía, madre soltera. Vivo con mis hijos en casa de familiares.",
				"No encuentro alquiler que pueda pagar con mi sueldo.",
				"Mis hijos merecen un hogar estable."
			],
			"responses": [
				"Los niños necesitan estabilidad",
				"¿Qué apoyo necesitas?",
				"Eres muy valiente"
			]
		},
		"Carmen Enferma": {
			"category": NPCCategory.SIN_SALUD,
			"dialog": [
				"Hola, soy Carmen. Estoy enferma pero no puedo pagar tratamiento.",
				"El sistema de salud me ha abandonado.",
				"La salud debe ser gratuita para todos."
			],
			"responses": [
				"La salud es un derecho fundamental",
				"¿Qué enfermedad tienes?",
				"El sistema debe cambiar"
			]
		},
		"Miguel Diabético": {
			"category": NPCCategory.SIN_SALUD,
			"dialog": [
				"Soy Miguel, diabético. No puedo comprar mi medicación.",
				"Sin insulina mi vida está en peligro.",
				"Necesitamos salud pública universal."
			],
			"responses": [
				"Todos merecemos medicinas gratis",
				"¿Has pedido ayuda al hospital?",
				"Qué situación tan grave"
			]
		},
		"Elena Cuidadora": {
			"category": NPCCategory.SIN_SALUD,
			"dialog": [
				"Soy Elena. Cuido a mi madre enferma sin ayuda.",
				"No hay servicios de apoyo para cuidadores.",
				"Necesitamos un sistema de cuidados."
			],
			"responses": [
				"Los cuidadores merecen apoyo",
				"¿Qué necesitas exactamente?",
				"Es muy duro cuidar sola"
			]
		},
		"Jorge Accidentado": {
			"category": NPCCategory.SIN_SALUD,
			"dialog": [
				"Soy Jorge. Tuve un accidente laboral grave.",
				"La empresa no se hace responsable de mi salud.",
				"Los trabajadores necesitamos protección."
			],
			"responses": [
				"Las empresas deben responder",
				"¿Qué tipo de accidente?",
				"Qué injusticia"
			]
		},
		"Lucia Estudiante": {
			"category": NPCCategory.SIN_EDUCACION,
			"dialog": [
				"Hola, soy Lucía. Quiero estudiar pero no puedo pagarlo.",
				"La educación no debería ser un privilegio.",
				"Todos merecemos acceso al conocimiento."
			],
			"responses": [
				"La educación debe ser gratuita",
				"¿Qué quieres estudiar?",
				"Es tu derecho"
			]
		},
		"David Desertor": {
			"category": NPCCategory.SIN_EDUCACION,
			"dialog": [
				"Soy David. Dejé los estudios para trabajar y ayudar en casa.",
				"Ahora no puedo progresar sin educación.",
				"Necesitamos que estudiar sea posible para todos."
			],
			"responses": [
				"Nunca es tarde para estudiar",
				"¿Te gustaría volver a estudiar?",
				"Muchos pasan por eso"
			]
		},
		"Patricia Maestra": {
			"category": NPCCategory.SIN_EDUCACION,
			"dialog": [
				"Soy Patricia, maestra. Veo cómo mis alumnos desertan por pobreza.",
				"El sistema educativo no apoya a quienes más lo necesitan.",
				"Educación de calidad para todos es posible."
			],
			"responses": [
				"Los maestros son fundamentales",
				"¿Qué propones para cambiar esto?",
				"Gracias por tu dedicación"
			]
		},
		"Antonio Adulto": {
			"category": NPCCategory.SIN_EDUCACION,
			"dialog": [
				"Soy Antonio. No sé leer bien y me cuesta encontrar trabajo.",
				"Nunca tuve oportunidad de estudiar de niño.",
				"La educación de adultos debe ser una prioridad."
			],
			"responses": [
				"Nunca es tarde para aprender",
				"¿Te interesaría aprender a leer?",
				"Todos merecemos segunda oportunidad"
			]
		},
		"Rosa Activista": {
			"category": NPCCategory.TRABAJO_PRECARIO,
			"dialog": [
				"Soy Rosa, activista de derechos humanos.",
				"He visto mucha injusticia pero también mucha fuerza en la gente.",
				"Unidos podemos cambiar el mundo."
			],
			"responses": [
				"¡Sí, cambiemos el mundo!",
				"¿Cómo empezamos?",
				"Me inspiras"
			]
		},
		"Manuel Veterano": {
			"category": NPCCategory.TRABAJO_PRECARIO,
			"dialog": [
				"Soy Manuel, veterano de muchas luchas sociales.",
				"He visto que organizados podemos lograr grandes cambios.",
				"¿Estás listo para organizarte?"
			],
			"responses": [
				"Estoy listo para organizarme",
				"Cuéntame de tus experiencias",
				"¿Qué consejo me das?"
			]
		},
		"Alex Joven": {
			"category": NPCCategory.SIN_EDUCACION,
			"dialog": [
				"Hola, soy Alex. Tengo muchas ganas de cambiar el mundo.",
				"Pero no sé por dónde empezar o cómo organizar a la gente.",
				"¿Me ayudas a aprender sobre organización comunitaria?"
			],
			"responses": [
				"¡Claro! Aprendamos juntos",
				"El primer paso es escuchar",
				"Tu energía es valiosa"
			]
		}
	}

## Obtiene los diálogos de un NPC por su nombre
func get_npc_dialog(npc_name: String) -> Dictionary:
	if npc_dialogs.has(npc_name):
		return npc_dialogs[npc_name]
	else:
		print("GameState: No se encontró diálogo para NPC: ", npc_name)
		return {
			"category": NPCCategory.TRABAJO_PRECARIO,
			"dialog": ["Hola, soy " + npc_name + ". Necesitamos organizarnos para defender nuestros derechos."],
			"responses": ["Me uno a la causa", "Cuéntame más", "En otro momento"]
		}

func _initialize_groups() -> void:
	# Inicializar diccionario de grupos por categoría
	for category in NPCCategory.values():
		organized_groups[category] = []

## Registra un NPC como contactado
func contact_npc(npc_data: Dictionary) -> void:
	# Verificar si ya está contactado
	for contacted in contacted_npcs:
		if contacted.get("id") == npc_data.get("id"):
			return
	
	contacted_npcs.append(npc_data)
	
	# Calcular energía colectiva
	collective_energy += ENERGY_PER_NPC
	
	print("NPC contactado: %s (%s) - Energía: %.1f" % [
		npc_data.get("name", "Sin nombre"),
		get_category_name(npc_data.get("category", NPCCategory.TRABAJO_PRECARIO)),
		collective_energy
	])
	
	npc_contacted.emit(npc_data)

## Intenta formar un grupo en un nodo de encuentro
func attempt_group_formation(category: NPCCategory, location: Vector3) -> bool:
	var category_npcs = _get_npcs_by_category(category)
	
	if category_npcs.size() < MIN_NPCS_FOR_GROUP:
		print("Insuficientes NPCs para formar grupo. Necesario: %d, Disponible: %d" % [
			MIN_NPCS_FOR_GROUP, category_npcs.size()
		])
		return false
	
	# Formar el grupo
	organized_groups[category] = category_npcs.slice(0, MIN_NPCS_FOR_GROUP)
	
	print("¡Grupo formado! Categoría: %s, Miembros: %d" % [
		get_category_name(category),
		organized_groups[category].size()
	])
	
	group_formed.emit(get_category_name(category), organized_groups[category].size())
	return true

## Ejecuta una acción colectiva
func perform_collective_action(action: ActionType) -> bool:
	var requirements = ACTION_COSTS.get(action, {})
	var required_groups = requirements.get("groups", 1)
	var required_energy = requirements.get("energy", 0.0)
	
	# Verificar requisitos
	var available_groups = _count_active_groups()
	if available_groups < required_groups:
		print("Grupos insuficientes para %s. Necesario: %d, Disponible: %d" % [
			get_action_name(action), required_groups, available_groups
		])
		return false
	
	if collective_energy < required_energy:
		print("Energía insuficiente para %s. Necesario: %.1f, Disponible: %.1f" % [
			get_action_name(action), required_energy, collective_energy
		])
		return false
	
	# Ejecutar acción
	collective_energy -= required_energy
	var pressure_gain = PRESSURE_PER_ACTION.get(action, 0.0)
	
	_add_social_pressure(pressure_gain)
	
	print("¡Acción ejecutada! %s - Presión ganada: %.1f" % [
		get_action_name(action), pressure_gain
	])
	
	collective_action_performed.emit(get_action_name(action))
	return true

## Añade presión social y verifica conquista de derechos
func _add_social_pressure(amount: float) -> void:
	var old_pressure = social_pressure
	social_pressure = min(social_pressure + amount, MAX_SOCIAL_PRESSURE)
	
	social_pressure_changed.emit(social_pressure)
	
	# Verificar si se puede conquistar un derecho
	if social_pressure >= MAX_SOCIAL_PRESSURE and old_pressure < MAX_SOCIAL_PRESSURE:
		_conquer_next_right()

## Conquista el próximo derecho disponible
func _conquer_next_right() -> void:
	var available_rights = []
	for right in RightType.values():
		if right not in conquered_rights:
			available_rights.append(right)
	
	if available_rights.is_empty():
		print("¡Todos los derechos han sido conquistados!")
		return
	
	var next_right = available_rights[0]
	conquered_rights.append(next_right)
	social_pressure = 0.0 # Reset para próximo derecho
	
	var right_name = get_right_name(next_right)
	print("¡DERECHO CONQUISTADO! %s" % right_name)
	
	right_conquered.emit(right_name)

## Utilidades para obtener NPCs por categoría
func _get_npcs_by_category(category: NPCCategory) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for npc in contacted_npcs:
		if npc.get("category") == category:
			result.append(npc)
	return result

## Cuenta grupos activos (con al menos MIN_NPCS_FOR_GROUP miembros)
func _count_active_groups() -> int:
	var count = 0
	for category in organized_groups.keys():
		if organized_groups[category].size() >= MIN_NPCS_FOR_GROUP:
			count += 1
	return count

## Getters para información del estado
func get_contacted_count() -> int:
	return contacted_npcs.size()

func get_organized_groups_count() -> int:
	return _count_active_groups()

func get_social_pressure_percentage() -> float:
	return (social_pressure / MAX_SOCIAL_PRESSURE) * 100.0

func get_conquered_rights_count() -> int:
	return conquered_rights.size()

## Utilidades de nombres legibles
func get_category_name(category: NPCCategory) -> String:
	match category:
		NPCCategory.TRABAJO_PRECARIO: return "Trabajo Precario"
		NPCCategory.SIN_VIVIENDA: return "Sin Vivienda"
		NPCCategory.SIN_SALUD: return "Sin Salud"
		NPCCategory.SIN_EDUCACION: return "Sin Educación"
		_: return "Desconocido"

func get_action_name(action: ActionType) -> String:
	match action:
		ActionType.MARCHA: return "Marcha"
		ActionType.ASAMBLEA: return "Asamblea"
		ActionType.HUELGA: return "Huelga"
		ActionType.FESTIVAL: return "Festival"
		_: return "Desconocida"

func get_right_name(right: RightType) -> String:
	match right:
		RightType.SALUD: return "Derecho a la Salud"
		RightType.EDUCACION: return "Derecho a la Educación"
		RightType.VIVIENDA: return "Derecho a la Vivienda"
		RightType.TRABAJO_DIGNO: return "Derecho al Trabajo Digno"
		_: return "Derecho Desconocido"

## Debug: Imprimir estado completo
func print_game_state() -> void:
	print("=== ESTADO DEL JUEGO ===")
	print("NPCs contactados: %d" % get_contacted_count())
	print("Grupos organizados: %d" % get_organized_groups_count())
	print("Energía colectiva: %.1f" % collective_energy)
	print("Presión social: %.1f%%" % get_social_pressure_percentage())
	print("Derechos conquistados: %d/4" % get_conquered_rights_count())

## Inicia una acción colectiva con duración
func start_collective_action(action_type: String, duration: float) -> bool:
	var action_requirements = {
		"march": {"npcs": 5, "groups": 1},
		"assembly": {"npcs": 8, "groups": 2},
		"strike": {"npcs": 15, "groups": 3},
		"festival": {"npcs": 20, "groups": 4}
	}
	
	var requirements = action_requirements.get(action_type, {})
	var contacted_count = get_contacted_npcs_count()
	var groups_count = organized_groups.size()
	
	# Verificar requisitos
	if contacted_count < requirements.get("npcs", 0):
		collective_action_failed.emit(action_type, "No hay suficientes contactos")
		return false
	
	if groups_count < requirements.get("groups", 0):
		collective_action_failed.emit(action_type, "No hay suficientes grupos organizados")
		return false
	
	# Iniciar acción
	collective_action_started.emit(action_type, duration)
	return true

## Completa una acción colectiva exitosamente
func complete_collective_action(action_type: String) -> void:
	var energy_gains = {
		"march": 15,
		"assembly": 25,
		"strike": 40,
		"festival": 30
	}
	
	var pressure_gains = {
		"march": 10.0,
		"assembly": 15.0,
		"strike": 25.0,
		"festival": 20.0
	}
	
	var energy_gain = energy_gains.get(action_type, 10)
	var pressure_gain = pressure_gains.get(action_type, 5.0)
	
	# Aplicar beneficios
	collective_energy += energy_gain
	_add_social_pressure(pressure_gain)
	
	collective_action_completed.emit(action_type, energy_gain)
	
	print("Acción %s completada: +%d energía, +%.1f presión" % [
		action_type, energy_gain, pressure_gain
	])

## Obtiene el número total de NPCs contactados (compatible con UI)
func get_contacted_npcs_count() -> int:
	return contacted_npcs.size()

## Emite señal de actualización de grupos (para UI)
func update_groups_display():
	groups_updated.emit()
extends Node2D

@export var niveles: Array[PackedScene]
@export var controlador_partida: GameplayLogger

var _nivel_actual: int = 1
var _nivel_instanciado: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if ControladorGlobal.level > 1:
		load_level()
	else:
		_create_level(_nivel_actual)

func _create_level(numero_nivel:int) -> void:
	_nivel_instanciado = niveles[numero_nivel-1].instantiate()
	add_child(_nivel_instanciado)
	
	var children := _nivel_instanciado.get_children() # := Haz que esta variable sea del tipo que le meto
	for i in children.size():
		if children[i].is_in_group("personajes"):
			children[i].personaje_muerto.connect(_restart_level)
			break
	#var personajes := get_tree().get_nodes_in_group("personajes")
	## only one character
	#personajes[0].personaje_muerto.connect(_restart_level)
	
	ControladorGlobal.level = numero_nivel
	controlador_partida.save_gameplay()
	
func _delete_level():
	_nivel_instanciado.queue_free()
	
func _restart_level():
	_delete_level()
	_create_level.call_deferred(_nivel_actual) # Se llama después de cargar el frame
	
func next_level():
	_nivel_actual += 1
	_delete_level()
	_create_level.call_deferred(_nivel_actual)
	
func load_level():
	_nivel_actual = ControladorGlobal.level
	_create_level.call_deferred(_nivel_actual) 
	

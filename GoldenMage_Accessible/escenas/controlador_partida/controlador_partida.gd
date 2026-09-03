class_name GameplayLogger
extends Node

@export var partida: GameplayData

var _route: String = "user://partida.tres" 
# No es q haya User como tal, es keyword so Godot saves en user default route
# En Windows es una carpeta en AppData porque siempre se suelen tener permisos wr


func save_gameplay():
	partida.level = ControladorGlobal.level
	partida.deaths = ControladorGlobal.deaths
	
	ResourceSaver.save(partida, _route)
	
	
func _load_gameplay():
	if ResourceLoader.exists(_route):
		partida = load(_route)
		
		ControladorGlobal.level = partida.level
		ControladorGlobal.deaths = partida.deaths

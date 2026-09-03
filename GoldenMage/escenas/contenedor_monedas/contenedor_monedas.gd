class_name ContenedorMonedas
extends Node

var _total_monedas: int
var _monedas_recogidas: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var monedas := get_children()
	_total_monedas = monedas.size()
	
	for moneda in monedas:
		moneda.contenedor_monedas = self
		
	
func collected_coin() -> void:
	_monedas_recogidas += 1
	
	if _monedas_recogidas == _total_monedas:
		print("Nivel superado")
		get_parent().get_parent().next_level()
		
	

extends Node

signal muertes_actualizado

var level: int
var deaths: int


func sum_death():
	deaths += 1
	muertes_actualizado.emit()

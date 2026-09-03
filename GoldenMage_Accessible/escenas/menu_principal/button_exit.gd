extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_exit)


func _exit():
	get_tree().quit() # Para cerrar el juego

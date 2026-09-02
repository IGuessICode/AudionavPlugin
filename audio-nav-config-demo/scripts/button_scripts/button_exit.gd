extends Button


func _ready() -> void:
	pressed.connect(_exit)

func _exit():
	get_tree().quit()

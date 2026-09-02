extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_load_menu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _load_menu():
	get_tree().change_scene_to_file("res://scenes/dummy_menu.tscn")

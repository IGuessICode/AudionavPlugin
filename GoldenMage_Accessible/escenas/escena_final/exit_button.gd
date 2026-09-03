extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(load_menu, 4) # 4 = ConnectFlags.CONNECT_ONE_SHOT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func load_menu():
	get_tree().change_scene_to_file("res://escenas/menu_principal/menu_principal.tscn")

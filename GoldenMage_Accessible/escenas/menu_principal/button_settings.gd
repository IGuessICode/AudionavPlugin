extends Button

func _ready() -> void:
	pressed.connect(load_settings) # 4 = ConnectFlags.CONNECT_ONE_SHOT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func load_settings():
	get_tree().change_scene_to_file("res://addons/audionav_plugin/scenes/audionav_setup/audionav_setup.tscn")

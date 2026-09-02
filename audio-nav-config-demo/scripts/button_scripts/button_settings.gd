extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(play) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func play():
	get_tree().change_scene_to_file("res://scenes/audionav_setup/audionav_setup.tscn")

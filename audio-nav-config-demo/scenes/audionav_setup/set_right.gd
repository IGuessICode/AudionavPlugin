extends Button


func _ready() -> void:
	pressed.connect(_on_pressed)
	
func _on_pressed():
	self.get_parent().get_parent().ongoing_setup = true
	self.get_parent().get_parent().direction_modified = "right"
	self.get_parent().get_parent().modified_bus = AudioServer.get_bus_index("AudionavRight")
	# Play sound from current bus setup for reference
	AudionavManager.play_from_single_bus(self.get_parent().get_parent().keysound_setup, "right")
	# AudionavSetup handles the rest
	

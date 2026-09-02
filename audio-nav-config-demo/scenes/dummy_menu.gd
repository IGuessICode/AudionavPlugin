extends Control
class_name DummyMenu

@onready var button_settings: Button = %ButtonSettings
@onready var button_exit: Button = %ButtonExit

func _ready() -> void:
	# NvdaWrapper.say("Hello World")
	button_settings.grab_focus()
	

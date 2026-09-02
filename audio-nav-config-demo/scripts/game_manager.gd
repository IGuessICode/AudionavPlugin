extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("TTS_repeat"):
		NvdaWrapper.repeat_last_message()

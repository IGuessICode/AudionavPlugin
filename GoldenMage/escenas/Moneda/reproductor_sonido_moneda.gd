extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finished.connect(_delete)


func _delete() -> void:
	queue_free()

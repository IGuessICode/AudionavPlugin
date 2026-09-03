extends Button

@export var escena_principal: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(play, 4) # 4 = ConnectFlags.CONNECT_ONE_SHOT
	#if !pressed.is_connected(_play):
		#pressed.connect(_play)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func play():
	# Borra datos de partida previos
	ControladorGlobal.level = 1
	ControladorGlobal.deaths = 0
	# Borra escena actual y carga la que le pasemos
	get_tree().change_scene_to_packed(escena_principal)
	#pressed.disconnect(_play)

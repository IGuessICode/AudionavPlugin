extends Button

@export var controlador_partida: GameplayLogger
@export var boton_jugar: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_load)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _load():
	controlador_partida._load_gameplay()
	boton_jugar.play()

extends Node2D

@export var area_2d: Area2D
@export var reproductor: AudioStreamPlayer2D

var contenedor_monedas: ContenedorMonedas

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.body_entered.connect(_gathering) 
	_start_animation()

func _gathering(_body) -> void:
	contenedor_monedas.collected_coin()
	reproductor.reparent(get_parent().get_parent().get_parent()) # Sonido hijo de contenedor para q le de tiempo a reproducirse
	reproductor.play()
	queue_free() # not draw in next frame

func _start_animation():
	var tween: Tween = create_tween() # Cambiar un valor durante x tiempo hasta que llegue a y valor
	tween.set_loops(0) # si 0 -> loops infinitos, si num particular then num
	tween.tween_property(self, "position:y", (position.y - 5), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	# Transition speed varies with "cubic", set_ease IN_OUT so it happens at beginning and end of transition
	tween.tween_property(self, "position:y", (position.y + 5), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	

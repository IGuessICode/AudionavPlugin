extends CharacterBody2D
## NOTES ##
# func _ready() -> void: # Se procesa nada más iniciarse el juego
	
# Delta es lo que se tarda en procesar cada frame por lo que puede variar de un ordenador a otro
# func _process(delta) -> void:
# 	position.x += 10 * delta # Así se moverá un pixel sin importar lo que tarde en procesarse

## CODE
signal personaje_muerto

@export var animation: Node
@export var area_2d: Area2D
@export var material_personaje_rojo: ShaderMaterial

var _velocidad: float = 100.0
var _velocidad_salto: float = -300.0
var _muerto: bool # False by default

func _init() -> void:
	add_to_group("personajes")
	

func _ready() -> void:
	area_2d.body_entered.connect(_on_area_2d_body_entered) 


func _physics_process(delta: float) -> void: # En teoria se llama 60 veces por segundo	
	if _muerto:
		return
	# gravedad
		# get_gravity returns vector2(x,y)
	velocity += get_gravity() * delta # Para que caiga según la velocidad a la que se procese el juego
	
	# salto
	if Input.is_action_just_pressed("saltar") && is_on_floor(): # ui_accept means spacebar
		velocity.y = _velocidad_salto
	
	# movimiento lateral
	if Input.is_action_pressed("right"):
		velocity.x = _velocidad
		animation.flip_h = true
	elif Input.is_action_pressed("left"):
		velocity.x = -_velocidad
		animation.flip_h = false
	else:
		velocity.x = 0
	move_and_slide()
	
	# animaciones
	if !is_on_floor():
		animation.play("saltar")
	elif velocity.x != 0:
		animation.play("correr")
	else:
		animation.play("idle")
	


func _on_area_2d_body_entered(_body: Node2D) -> void:
	# _arg is convention for arg that will not be used but needs to be there bcuz function calling is done with parameter
	animation.material = material_personaje_rojo
	# animation.modulate = Color(18.892, 0.0, 0.0, 1.0) #R,G,B,Intensidad
	_muerto = true
	animation.stop()
	
	await get_tree().create_timer(0.5).timeout
	personaje_muerto.emit()
	
	ControladorGlobal.sum_death()
	
	# print("muerto")

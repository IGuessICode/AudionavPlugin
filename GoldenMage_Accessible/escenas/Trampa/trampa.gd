extends RigidBody2D

@export var raycast: RayCast2D

func _physics_process(delta: float) -> void:
	if raycast.get_collider() != null: # por claridad, tb se puede poner solo if raycast.get_collider():
		freeze = false

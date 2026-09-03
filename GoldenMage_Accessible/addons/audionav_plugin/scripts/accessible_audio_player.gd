class_name AccessibleAudioPlayer
extends AudioStreamPlayer

## SIGNALS
signal PLAY_KEYSOUND(audio_player: AccessibleAudioPlayer)

## VARIABLES
# Adds to usual properties of Node the accesible attributes: key_sound, _is_audible
@export var key_sound: KeySoundPreset
@export var emission_radius: int # in px

# Variables configured by code
var now_playing: bool = false # Verifies audio has been correctly sent to Audionav Manager
var relative_distance: Vector2 # distance between self and node "Player" --> TBD: Change to adjustable cirumference 

# Player instance
var player_node: Node2D = null

## FUNCTIONS
func _enter_tree() -> void:
	if Engine.is_editor_hint():
		print("Hello!")
		for child in get_children():
			if child is KeysoundEffectArea: return # Only one area per node
			var emission_area: KeysoundEffectArea = KeysoundEffectArea.new()
			emission_area.name = "KeysoundEffectArea_" + self.name
			add_child(emission_area, false, Node.INTERNAL_MODE_BACK)

# Called when the node is loaded for the first time.
func _ready() -> void:
	# Bind signal to manager so, later, it knows who emitted it
	PLAY_KEYSOUND.connect(AudionavManager.on_play_sound.bind(self))
	
	# Look for player(s) and obtain location
	var player = get_tree().get_nodes_in_group("personajes")
	if !player.is_empty():
		player_node = player[0]
	else:
		print("ERROR: No node Player found. Cannot reference audionav")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!now_playing) && (player_node != null):
		# Change the centre of coordinates from ref to the player as the origin. 
		relative_distance = self.get_parent().position - player_node.position
		var relative_distance_diagonal = pow(relative_distance.x, 2) + pow(relative_distance.y, 2)
		# Scale the Debug emission radius to the size of the screen
		var scaled_radius = (get_viewport().size.x / (16+14)) * emission_radius
		# print("Scale radius= ", get_viewport().size.x / (16+14)) # FOR DEBUG
		# Check if node is within audible range
		if relative_distance_diagonal <= scaled_radius:
			now_playing = true
			print("Playing keysound from node ", self.get_parent().name)
			PLAY_KEYSOUND.emit() # Because of .bind in _ready, sends signal+intance of node

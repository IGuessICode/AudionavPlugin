# AudionavManager -- Autoload singleton with Global scope
extends Node

var _routeKeysounds: String = "res://addons/audionav_plugin/resources/keysounds"
var key_sound_presets: Array[KeySoundPreset]

var _routeProfile: String = "res://addons/audionav_plugin/resources/audionav_profile.tres" # Save user audio config in default route
var audionav_profile: AudionavProfile

### Signals
signal AUDIONAV_PLAY_PANNED

### Variables
var _max_audiostreams: int = 3 # 3 + bg_music = 4 audio sources MAX to avoid saturation
var _playing_audiostreams: int

### Functions
## Audio config management
func save_bus(bus_name: String):
	## SAVE BUS LAYOUT -> Overwrite Master so only 1 bus per layout
	match bus_name:
		"left":
			# Find modified bus
			var idx:int = AudioServer.get_bus_index("AudionavLeft") # Format: AudionavDirection
			# Copy bus properties to profile bus
			audionav_profile.AudionavLeft["volume_db"] = AudioServer.get_bus_volume_db(idx)
			audionav_profile.AudionavLeft["send"] = AudioServer.get_bus_send(idx)
						# Pan + Reverb
			var effect_count = AudioServer.get_bus_effect_count(idx)
			if effect_count == 0:
				push_error("Bus " + bus_name + "has no effects. Audionav profile saving incompleted.")
			else:
				audionav_profile.AudionavLeft["panning_enabled"] = true
				audionav_profile.AudionavLeft["pan"] = AudioServer.get_bus_effect(idx, 0).pan
				audionav_profile.AudionavLeft["reverb_enabled"] = false
			
		"right":
			# Find modified bus
			var idx:int = AudioServer.get_bus_index("AudionavRight") # Format: AudionavDirection
			# Copy bus properties to profile bus
			audionav_profile.AudionavRight["volume_db"] = AudioServer.get_bus_volume_db(idx)
			audionav_profile.AudionavRight["send"] = AudioServer.get_bus_send(idx)
						# Pan + Reverb
			var effect_count = AudioServer.get_bus_effect_count(idx)
			if effect_count == 0:
				push_error("Bus " + bus_name + "has no effects. Audionav profile saving incompleted.")
			else:
				audionav_profile.AudionavRight["panning_enabled"] = true
				audionav_profile.AudionavRight["pan"] = AudioServer.get_bus_effect(idx, 0).pan
				audionav_profile.AudionavRight["reverb_enabled"] = false
		"front":
			# Find modified bus
			var idx:int = AudioServer.get_bus_index("AudionavFront") # Format: AudionavDirection
			# Copy bus properties to profile bus
			audionav_profile.AudionavFront["volume_db"] = AudioServer.get_bus_volume_db(idx)
			audionav_profile.AudionavFront["send"] = AudioServer.get_bus_send(idx)
						# Pan + Reverb
			var effect_count = AudioServer.get_bus_effect_count(idx)
			if effect_count == 0:
				push_error("Bus " + bus_name + "has no effects. Audionav profile saving incompleted.")
			else:
				audionav_profile.AudionavFront["panning_enabled"] = true
				audionav_profile.AudionavFront["pan"] = AudioServer.get_bus_effect(idx, 0).pan
				audionav_profile.AudionavFront["reverb_enabled"] = true
				audionav_profile.AudionavFront["room_size"] = AudioServer.get_bus_effect(idx, 1).room_size
				audionav_profile.AudionavFront["damping"] = AudioServer.get_bus_effect(idx, 1).damping
				audionav_profile.AudionavFront["spread"] = AudioServer.get_bus_effect(idx, 1).spread
				audionav_profile.AudionavFront["wet"] = AudioServer.get_bus_effect(idx, 1).wet
				audionav_profile.AudionavFront["predelay_msec"] = AudioServer.get_bus_effect(idx, 1).predelay_msec
		"back":
			# Find modified bus
			var idx:int = AudioServer.get_bus_index("AudionavBack") # Format: AudionavDirection
			# Copy bus properties to profile bus
			audionav_profile.AudionavBack["volume_db"] = AudioServer.get_bus_volume_db(idx)
			audionav_profile.AudionavBack["send"] = AudioServer.get_bus_send(idx)
						# Pan + Reverb
			var effect_count = AudioServer.get_bus_effect_count(idx)
			if effect_count == 0:
				push_error("Bus " + bus_name + "has no effects. Audionav profile saving incompleted.")
			else:
				audionav_profile.AudionavBack["panning_enabled"] = true
				audionav_profile.AudionavBack["pan"] = AudioServer.get_bus_effect(idx, 0).pan
				audionav_profile.AudionavBack["reverb_enabled"] = true
				audionav_profile.AudionavBack["room_size"] = AudioServer.get_bus_effect(idx, 1).room_size
				audionav_profile.AudionavBack["damping"] = AudioServer.get_bus_effect(idx, 1).damping
				audionav_profile.AudionavBack["spread"] = AudioServer.get_bus_effect(idx, 1).spread
				audionav_profile.AudionavBack["wet"] = AudioServer.get_bus_effect(idx, 1).wet
				audionav_profile.AudionavBack["predelay_msec"] = AudioServer.get_bus_effect(idx, 1).predelay_msec
		_:
			push_error("Cannot save bus " + bus_name + ". Bus name could not be found.")
	
	ResourceSaver.save(audionav_profile, _routeProfile)
	

func load_profile():
	## LOAD BUS LAYOUT
	# Find existing buses
	var left_idx = AudioServer.get_bus_index("AudionavLeft")
	var right_idx = AudioServer.get_bus_index("AudionavRight")
	var back_idx = AudioServer.get_bus_index("AudionavBack")
	var front_idx = AudioServer.get_bus_index("AudionavFront")
	
	# Create/Load bus properties
	# LEFT
	if left_idx != null:
		AudioServer.set_bus_volume_db(left_idx, audionav_profile.AudionavLeft["volume_db"])
		AudioServer.set_bus_send(left_idx, audionav_profile.AudionavLeft["send"])
		AudioServer.get_bus_effect(left_idx, 0).pan = audionav_profile.AudionavLeft["pan"]
	else:
		# Add audio bus layout for Audio Navigation LEFT
		var last_bus_idx: int = AudioServer.bus_count - 1 # First position index is 0
		var bus = audionav_profile.AudionavLeft
		AudioServer.add_bus(last_bus_idx)
		# Copy parameters of temp_bus to the newly created one
		AudioServer.set_bus_name(last_bus_idx, bus["name"])
		AudioServer.set_bus_volume_db(last_bus_idx, bus["volume_db"])
		AudioServer.set_bus_send(front_idx, audionav_profile.AudionavFront["send"])
			# All Effects
		if bus["panning_enabled"]:
			var panner = AudioServer.get_bus_effect(last_bus_idx, 0)
			panner.pan = bus["pan"]
		if bus["reverb_enabled"]:
			var reverb = AudioServer.get_bus_effect(last_bus_idx, 1)
			reverb.room_size = bus["room_size"]
			reverb.damping = bus["damping"]
			reverb.spread = bus["spread"]
			reverb.wet = bus["wet"]
			reverb.predelay_msec = bus["predelay_msec"]
			
	# RIGHT
	if right_idx != null:
		AudioServer.set_bus_volume_db(right_idx, audionav_profile.AudionavRight["volume_db"])
		AudioServer.set_bus_send(right_idx, audionav_profile.AudionavRight["send"])
		AudioServer.get_bus_effect(right_idx, 0).pan = audionav_profile.AudionavRight["pan"]
	else:
		# Add audio bus layout for Audio Navigation LEFT
		var last_bus_idx: int = AudioServer.bus_count - 1 # First position index is 0
		var bus = audionav_profile.AudionavLeft
		AudioServer.add_bus(last_bus_idx)
		# Copy parameters of temp_bus to the newly created one
		AudioServer.set_bus_name(last_bus_idx, bus["name"])
		AudioServer.set_bus_volume_db(last_bus_idx, bus["volume_db"])
		AudioServer.set_bus_send(front_idx, audionav_profile.AudionavFront["send"])
			# All Effects
		if bus["panning_enabled"]:
			var panner = AudioServer.get_bus_effect(last_bus_idx, 0)
			panner.pan = bus["pan"]
		if bus["reverb_enabled"]:
			var reverb = AudioServer.get_bus_effect(last_bus_idx, 1)
			reverb.room_size = bus["room_size"]
			reverb.damping = bus["damping"]
			reverb.spread = bus["spread"]
			reverb.wet = bus["wet"]
			reverb.predelay_msec = bus["predelay_msec"]
		
	# BACK
	if back_idx != null:
		AudioServer.set_bus_volume_db(back_idx, audionav_profile.AudionavBack["volume_db"])
		AudioServer.set_bus_send(back_idx, audionav_profile.AudionavBack["send"])
		AudioServer.get_bus_effect(back_idx, 0).pan = audionav_profile.AudionavBack["pan"]
		var reverb = AudioServer.get_bus_effect(back_idx, 1)
		reverb.room_size = audionav_profile.AudionavBack["room_size"]
		reverb.damping = audionav_profile.AudionavBack["damping"]
		reverb.spread = audionav_profile.AudionavBack["spread"]
		reverb.wet = audionav_profile.AudionavBack["wet"]
		reverb.predelay_msec = audionav_profile.AudionavBack["predelay_msec"]
	else:
		# Add audio bus layout for Audio Navigation LEFT
		var last_bus_idx: int = AudioServer.bus_count - 1 # First position index is 0
		var bus = audionav_profile.AudionavBack
		AudioServer.add_bus(last_bus_idx)
		# Copy parameters of temp_bus to the newly created one
		AudioServer.set_bus_name(last_bus_idx, bus["name"])
		AudioServer.set_bus_volume_db(last_bus_idx, bus["volume_db"])
		AudioServer.set_bus_send(front_idx, audionav_profile.AudionavFront["send"])
			# All Effects
		if bus["panning_enabled"]:
			var panner = AudioServer.get_bus_effect(last_bus_idx, 0)
			panner.pan = bus["pan"]
		if bus["reverb_enabled"]:
			var reverb = AudioServer.get_bus_effect(last_bus_idx, 1)
			reverb.room_size = bus["room_size"]
			reverb.damping = bus["damping"]
			reverb.spread = bus["spread"]
			reverb.wet = bus["wet"]
			reverb.predelay_msec = bus["predelay_msec"]
	
	# FRONT
	if front_idx != null:
		AudioServer.set_bus_volume_db(front_idx, audionav_profile.AudionavFront["volume_db"])
		AudioServer.set_bus_send(front_idx, audionav_profile.AudionavFront["send"])
		AudioServer.get_bus_effect(front_idx, 0).pan = audionav_profile.AudionavFront["pan"]
		var reverb = AudioServer.get_bus_effect(front_idx, 1)
		reverb.room_size = audionav_profile.AudionavFront["room_size"]
		reverb.damping = audionav_profile.AudionavFront["damping"]
		reverb.spread = audionav_profile.AudionavFront["spread"]
		reverb.wet = audionav_profile.AudionavFront["wet"]
		reverb.predelay_msec = audionav_profile.AudionavFront["predelay_msec"]
	else:
		# Add audio bus layout for Audio Navigation LEFT
		var last_bus_idx: int = AudioServer.bus_count - 1 # First position index is 0
		var bus = audionav_profile.AudionavBack
		AudioServer.add_bus(last_bus_idx)
		# Copy parameters of temp_bus to the newly created one
		AudioServer.set_bus_name(last_bus_idx, bus["name"])
		AudioServer.set_bus_volume_db(last_bus_idx, bus["volume_db"])
		AudioServer.set_bus_send(front_idx, audionav_profile.AudionavFront["send"])
			# All Effects
		if bus["panning_enabled"]:
			var panner = AudioServer.get_bus_effect(last_bus_idx, 0)
			panner.pan = bus["pan"]
		if bus["reverb_enabled"]:
			var reverb = AudioServer.get_bus_effect(last_bus_idx, 1)
			reverb.room_size = bus["room_size"]
			reverb.damping = bus["damping"]
			reverb.spread = bus["spread"]
			reverb.wet = bus["wet"]
			reverb.predelay_msec = bus["predelay_msec"]
	

func create_profile():
	# TBD: Future feature to be implemented with profile handling 
	pass
	
func add_effect_area():
	print("There is an ACCESSIBLE_AUDIOPLAYER in the scene tree")

## Godot "Life-Cycle" processing functions
func _init():
	# Enable Always Process so audionavigation setup can still work when the game is paused by the player.
	process_mode = Node.PROCESS_MODE_ALWAYS
	_playing_audiostreams = 0
	
	# Load profile
	if ResourceLoader.exists(_routeProfile):
			audionav_profile = load(_routeProfile)
	else:
		push_error("Could not load Audionav Profile in path " + _routeProfile)
		
func _ready() -> void:
	# Load existing keysounds (names) in Array
	var _keysoundsPaths:PackedStringArray
	_keysoundsPaths = ResourceLoader.list_directory(_routeKeysounds)
	print("Available keysounds: ")
	print(_keysoundsPaths)
	
	# Load each keysound in array
	var i:int = 0
	var temp_rsc:KeySoundPreset
	for _path in _keysoundsPaths:
		var full_path = _routeKeysounds+ "/" + _path
		if ResourceLoader.exists(full_path):
			temp_rsc = load(full_path)
			key_sound_presets.append(temp_rsc)
			i += 1
		else:
			push_error("Could not load Audionav Keysounds in path " + full_path)
		
	

## Audio Navigation functions
func on_play_sound(audio_emitter: AccessibleAudioPlayer):
	# Run when signal PLAY is received
	print("Sound played by: ", audio_emitter.get_parent().name)
	# Check if the maximum audio sources has been reached 
	print("Current audio streams: ", _playing_audiostreams)
	if _playing_audiostreams < _max_audiostreams:
		_playing_audiostreams += 1
		# Store audiostream in a temp variable for manipulation
		var temp_audiostream: AudioStream
		if audio_emitter.key_sound == null:
			temp_audiostream = _keysound_assign_by_mask()
		else:
			temp_audiostream = audio_emitter.key_sound.audio_sample
		
		_play_from_position(temp_audiostream, audio_emitter.relative_distance, audio_emitter.emission_radius)
		
	else:
		print("Sound by ", audio_emitter.get_parent().name, " cannot be played. MAX Audiostreams reached")
		audio_emitter.now_playing = false
	

func _keysound_assign_by_mask():
	# TBD:
	pass

func _play_from_position(keysound: AudioStream, position: Vector2, emission_radius: int):
	# Create panned sound by sending weighted versions of the audio stream to selected audio buses.
	var gain_L: float = 0
	var gain_R: float = 0
	var gain_F: float = 0
	var gain_B: float = 0

	# Calculate weight Left-Right by normalizing the vector [0, 1]
	if position.x > 0:
		gain_R = (position.x - 0) / (emission_radius - 0)
	if position.x < 0:
		gain_L = (abs(position.x) - 0) / (emission_radius - 0)
	# Calculate weight Front-Back
	if position.y < 0:
		gain_F = (position.y - 0) / (emission_radius - 0)
	if position.y > 0:
		gain_B = (abs(position.y) - 0) / (emission_radius - 0)
	# Play: Stream -> Player_X -> Audionav_X
	print("Sending ", keysound, " to Left", gain_L, ", to Right", gain_R, ", to Front", gain_F, " and to Back", gain_B)
	AUDIONAV_PLAY_PANNED.emit(keysound, gain_L, gain_R, gain_F, gain_B)	
	

func play_from_single_bus(keysound: AudioStream, target_bus: String):
	# Used during panning setup.
	# "Mute" all buses except the one being modified and play sound with unit gain.
	# Modification of the bus' properties themselves is done from audionav_setup.gd
	match target_bus:
		"left":
			AUDIONAV_PLAY_PANNED.emit(keysound, 1, 0, 0, 0)
		"right":
			AUDIONAV_PLAY_PANNED.emit(keysound, 0, 1, 0, 0)
		"front":
			AUDIONAV_PLAY_PANNED.emit(keysound, 0, 0, 1, 0)
		"back":
			AUDIONAV_PLAY_PANNED.emit(keysound, 0, 0, 0, 1)
		_:
			push_error("Cannot play from bus " + target_bus + ". Bus name could not be found.") 
		

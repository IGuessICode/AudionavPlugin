extends Control

var ongoing_setup: bool
var confirm_bus: bool
var direction_modified: String # Modified by Set+Direction and used as arg by saveBus
var modified_bus: int # Stores index of the bus of the direction that is being setup

var keysound_setup = AudioStream

# Dev can choose for users the "panning fader"'s step size
@export_range(0.05, 0.5) var _panning_step: float = 0.3
@export_range(0.1, 5) var _delay_step: float = 3
@export_range(1, 5) var _volume_step: float = 1
# Points to the Container with the buttons to do the setup for each Direction bus
@export var _direction_menu: VBoxContainer

## FOR DEBUG
#@export var _keysound: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Reset variable values
	ongoing_setup = false
	confirm_bus = false
	
	# Load keysound for setup for later use
	for item in AudionavManager.key_sound_presets: 
		if item.type == KeySoundPreset.KEY_SOUND_PRESET_NAME["SETUP_SOUND"]: 
			keysound_setup = item.audio_sample
			break
	# keysound_setup = _keysound
	
	# Connect to pressed signals of Direction menu to switch to editing UI
	var direction_buttons = _direction_menu.get_children()
	for buttons in direction_buttons:
		buttons.pressed.connect(_update_setup_ui)
	

func _process(delta: float) -> void:
	if ongoing_setup:
		confirm_bus = Input.is_action_pressed("accept")
		if confirm_bus:
			ongoing_setup = false
			confirm_bus = false
			modified_bus = 0
			AudionavManager.save_bus(direction_modified)
			_update_setup_ui()
		else:
			# Play sound from only one AudioNav Bus, modify properties with direction arrows
			if !modified_bus==0:
				if Input.is_action_pressed("left"):
					AudioServer.get_bus_effect(modified_bus, 0).pan = AudioServer.get_bus_effect(modified_bus, 0).pan - _panning_step
					AudionavManager.play_from_single_bus(keysound_setup, direction_modified)
					
				if Input.is_action_pressed("right"): 
					AudioServer.get_bus_effect(modified_bus, 0).pan = AudioServer.get_bus_effect(modified_bus, 0).pan + _panning_step
					AudionavManager.play_from_single_bus(keysound_setup, direction_modified)

				if Input.is_action_pressed("down"): 
					AudioServer.set_bus_volume_db(modified_bus, (AudioServer.get_bus_volume_db(modified_bus) - _volume_step))
					AudioServer.get_bus_effect(modified_bus, 1).set_predelay_msec(AudioServer.get_bus_effect(modified_bus, 1).get_predelay_msec() + _delay_step)
					# AudioServer.get_bus_effect(modified_bus, 1).msec = AudioServer.get_bus_effect(modified_bus, 1).msec - _delay_step
					AudionavManager.play_from_single_bus(keysound_setup, direction_modified)
					
				if Input.is_action_pressed("up"): 
					AudioServer.set_bus_volume_db(modified_bus, (AudioServer.get_bus_volume_db(modified_bus) + _volume_step))
					AudioServer.get_bus_effect(modified_bus, 1).set_predelay_msec(AudioServer.get_bus_effect(modified_bus, 1).get_predelay_msec() - _delay_step)
					AudionavManager.play_from_single_bus(keysound_setup, direction_modified)
					


func _update_setup_ui():
	# Disable/Enable direction buttons while editing so input direction does not collide with button navigation
	if ongoing_setup: 
		_direction_menu.mouse_filter = MOUSE_FILTER_IGNORE
		_direction_menu.visible = false
		
	else: 
		_direction_menu.mouse_filter = MOUSE_FILTER_PASS
		_direction_menu.visible = true
	

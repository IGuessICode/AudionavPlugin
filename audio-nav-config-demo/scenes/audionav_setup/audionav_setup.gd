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

@export var _exit_button: Button

# For TTS - Button instances
@onready var tts_component: TTSComponent = %TTSComponent
var focused_button: Button

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
	for button in direction_buttons:
		button.pressed.connect(_update_setup_ui)
		button.focus_entered.connect(_on_button_focused.bind(button))
		
		if button.name == "SetLeft":
			tts_component.add_tts_node(button, button.text, "After click, Move the following sound until you can hear it coming from your left, then hit enter or space bar.")
		if button.name == "SetRight":
			tts_component.add_tts_node(button, button.text, "After click, Move the following sound until you can hear it coming from your right, then hit enter or space bar.")
		if button.name == "SetFront":
			tts_component.add_tts_node(button, button.text, "After click, Move the following sound until you can hear it coming from in front of you, then hit enter or space bar.")
		if button.name == "SetBack":
			tts_component.add_tts_node(button, button.text, "After click, Move the following sound until you can hear it coming from behind you, then hit enter or space bar.")
		

	
	# TTS CONFIG STUFF
	_direction_menu.get_child(0).grab_focus()

func _process(delta: float) -> void:
	if ongoing_setup:
		confirm_bus = Input.is_action_pressed("ui_accept")
		if confirm_bus:
			ongoing_setup = false
			confirm_bus = false
			modified_bus = 0
			AudionavManager.save_bus(direction_modified)
			_update_setup_ui()
		else:
			# Play sound from only one AudioNav Bus, modify properties with direction arrows
			if !modified_bus==0:
				if Input.is_action_pressed("ui_left"):
					AudioServer.get_bus_effect(modified_bus, 0).pan = AudioServer.get_bus_effect(modified_bus, 0).pan - _panning_step
					AudionavManager.play_from_single_bus(keysound_setup, direction_modified)
					
				if Input.is_action_pressed("ui_right"): 
					AudioServer.get_bus_effect(modified_bus, 0).pan = AudioServer.get_bus_effect(modified_bus, 0).pan + _panning_step
					AudionavManager.play_from_single_bus(keysound_setup, direction_modified)

				if Input.is_action_pressed("ui_down"): 
					AudioServer.set_bus_volume_db(modified_bus, (AudioServer.get_bus_volume_db(modified_bus) - _volume_step))
					AudioServer.get_bus_effect(modified_bus, 1).set_predelay_msec(AudioServer.get_bus_effect(modified_bus, 1).get_predelay_msec() + _delay_step)
					# AudioServer.get_bus_effect(modified_bus, 1).msec = AudioServer.get_bus_effect(modified_bus, 1).msec - _delay_step
					AudionavManager.play_from_single_bus(keysound_setup, direction_modified)
					
				if Input.is_action_pressed("ui_up"): 
					AudioServer.set_bus_volume_db(modified_bus, (AudioServer.get_bus_volume_db(modified_bus) + _volume_step))
					AudioServer.get_bus_effect(modified_bus, 1).set_predelay_msec(AudioServer.get_bus_effect(modified_bus, 1).get_predelay_msec() - _delay_step)
					AudionavManager.play_from_single_bus(keysound_setup, direction_modified)
					

func _update_setup_ui():
	# Disable/Enable direction buttons while editing so input direction does not collide with button navigation
	if ongoing_setup:
		NvdaWrapper.stop()
		AudioServer.set_bus_mute(AudioServer.get_bus_index("BGM"),true)
		_direction_menu.mouse_filter = MOUSE_FILTER_IGNORE
		_direction_menu.visible = false
		_exit_button.mouse_filter = MOUSE_FILTER_IGNORE
		_exit_button.visible = false
		
	else: 
		_direction_menu.mouse_filter = MOUSE_FILTER_PASS
		_direction_menu.visible = true
		_exit_button.mouse_filter = MOUSE_FILTER_PASS
		_exit_button.visible = true
		focused_button.grab_focus()
		AudioServer.set_bus_mute(AudioServer.get_bus_index("BGM"),false)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("TTS_details"):
		# print("D pressed")
		tts_component.read_details(focused_button)

func _on_button_focused(_button: Button):
	focused_button = _button

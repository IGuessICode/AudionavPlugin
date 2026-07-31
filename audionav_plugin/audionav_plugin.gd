@tool
extends EditorPlugin

var _route: String = "res://addons/audionav_plugin/resources/audionav_profile.tres" 
var audionav_local_profile:AudionavProfile
var audio_buses: Array[Dictionary]

#func _enable_plugin() -> void:
	## Load Audionav Manager
	#add_autoload_singleton(MANAGER_NAME, "res://addons/audionav_plugin/scripts/audionav_manager.gd")
	#
	## Add audio bus layout for Audio Navigation
	#var last_bus_idx: int = AudioServer.bus_count - 1 # First position index is 0
	#
	#if ResourceLoader.exists(_route):
		#audionav_local_profile = load(_route)
		#audio_buses = [audionav_local_profile.AudionavLeft, audionav_local_profile.AudionavRight, 
		#audionav_local_profile.AudionavFront, audionav_local_profile.AudionavBack]
		#for bus in audio_buses:
			## Check if bus exists already
			#if AudioServer.get_bus_index(bus.name) > 0: # get_bus_index returns -1 if not found
				## Create new bus in current bus layout
				#last_bus_idx += 1
				#AudioServer.add_bus(last_bus_idx)
				## Copy parameters of temp_bus to the newly created one
				#AudioServer.set_bus_name(last_bus_idx, bus.name)
				#AudioServer.set_bus_volume_db(last_bus_idx, bus.volume_db)
					## All Effects
				#if bus.panning_enabled:
					#var panner = AudioEffectPanner.new()
					#panner.pan = bus.pan
					#AudioServer.add_bus_effect(last_bus_idx, panner, 0)
					#
				#if bus.reverb_enabled:
					#var reverb = AudioEffectReverb.new()
					#reverb.room_size = bus.room_size
					#reverb.damping = bus.damping
					#reverb.spread = bus.spread
					#reverb.wet = bus.wet
					#reverb.predelay_msec = bus.predelay_msec
					#AudioServer.add_bus_effect(last_bus_idx, reverb, 1)
	

#func _disable_plugin() -> void:
	#remove_autoload_singleton(MANAGER_NAME)
	#
	## Look for AudioBus and delete them
	#var bus_idxs = [AudioServer.get_bus_index("AudionavLeft"), AudioServer.get_bus_index("AudionavRight"),
	 #AudioServer.get_bus_index("AudionavFront"), AudioServer.get_bus_index("AudionavBack")]
	#for idx in bus_idxs:
		#if idx > 0:
			#AudioServer.remove_bus(idx)
	


func _enter_tree() -> void:
	# Add Manager as a Globals script
	add_autoload_singleton("AudionavManager", "res://addons/audionav_plugin/scripts/audionav_manager.gd")
	
	# Load custom nodes so they can be selected from editor Scene>Add/Create New Node/Child
	add_custom_type("Accessible Audio Player", "AudioStreamPlayer", preload("res://addons/audionav_plugin/scripts/accessible_audio_player.gd"), preload("res://addons/audionav_plugin/icons/accessible_audioplayer_icon.png"))
	add_custom_type("Audionav Player", "Node", preload("res://addons/audionav_plugin/scripts/audionav_player.gd"), preload("res://addons/audionav_plugin/icons/audionav_player_icon.png"))
	# TBD: Add custom type key sound preset
	
	# Add audio bus layout for Audio Navigation
	var last_bus_idx: int = AudioServer.bus_count - 1 # First position index is 0
	
	if ResourceLoader.exists(_route):
		print("Audionav profile found")
		audionav_local_profile = load(_route)
		audio_buses = [audionav_local_profile.AudionavLeft, audionav_local_profile.AudionavRight, 
		audionav_local_profile.AudionavFront, audionav_local_profile.AudionavBack]
		print("Buses in profile: ", len(audio_buses))
		for bus in audio_buses:
			# Check if bus exists already
			if AudioServer.get_bus_index(bus.name) < 0: # get_bus_index returns -1 if not found
				# Create new bus in current bus layout
				last_bus_idx += 1
				AudioServer.add_bus(last_bus_idx)
				# Copy parameters of temp_bus to the newly created one
				AudioServer.set_bus_name(last_bus_idx, bus.name)
				AudioServer.set_bus_volume_db(last_bus_idx, bus.volume_db)
					# All Effects
				if bus.panning_enabled:
					var panner = AudioEffectPanner.new()
					panner.pan = bus.pan
					AudioServer.add_bus_effect(last_bus_idx, panner, 0)
					
				if bus.reverb_enabled:
					var reverb = AudioEffectReverb.new()
					reverb.room_size = bus.room_size
					reverb.damping = bus.damping
					reverb.spread = bus.spread
					reverb.wet = bus.wet
					reverb.predelay_msec = bus.predelay_msec
					AudioServer.add_bus_effect(last_bus_idx, reverb, 1)
	

func _exit_tree() -> void:
	remove_autoload_singleton("AudionavManager")
	remove_custom_type("Accessible Audio Player")
	remove_custom_type("Audionav Player")
	# TBD: Remove key sound preset
	
	# Look for AudioBus and delete them
	var bus_idxs = [AudioServer.get_bus_index("AudionavLeft"), AudioServer.get_bus_index("AudionavRight"),
	 AudioServer.get_bus_index("AudionavFront"), AudioServer.get_bus_index("AudionavBack")]
	for idx in bus_idxs:
		if idx > 0:
			AudioServer.remove_bus(idx)
	
	

class_name AudionavPlayer
extends Node
# Adapted from comment by 1ai13 on https://docs.godotengine.org/en/4.5/classes/class_audiostreampolyphonic.html

# Define audio players for each bus
var player_right: AudioStreamPlayer = AudioStreamPlayer.new()
var player_left: AudioStreamPlayer = AudioStreamPlayer.new()
var player_front: AudioStreamPlayer = AudioStreamPlayer.new()
var player_back: AudioStreamPlayer = AudioStreamPlayer.new()


func _init() -> void:
	# Add players as children that cannot be viewed in Editor>Scene tree to avoid visually convoluted Scene Tree
	self.add_child(player_right, true, Node.INTERNAL_MODE_BACK)
	self.add_child(player_left, true, Node.INTERNAL_MODE_BACK) 
	self.add_child(player_front, true, Node.INTERNAL_MODE_BACK) 
	self.add_child(player_back, true, Node.INTERNAL_MODE_BACK) 
	
	# Modify properties of the audioplayers to match needs
	for child in self.get_children(true):
		print("Child name is: " + child.name)
		match child.name:
			"AudioStreamPlayer":
				child.name = "player_right"
				child.bus = "AudionavRight"
			"AudioStreamPlayer2":
				child.name = "player_left"
				child.bus = "AudionavLeft"
			"AudioStreamPlayer3":
				child.name = "player_back"
				child.bus = "AudionavBack"
			"AudioStreamPlayer4":
				child.name = "player_front"
				child.bus = "AudionavFront"
			_:
				push_error("Child could not be found by name")
				
		child.max_polyphony = 4
		child.stream = AudioStreamPolyphonic.new()
		print("Child name is now: " + child.name)
				
	
	
func _ready() -> void:
	for child in self.get_children(true):
		# Playing it without AudioStream for later PolyphonicPlayback assignment without errors
		child.play()
		print("Player " + child.name + "has been initiated successfully.")
		
	AudionavManager.AUDIONAV_PLAY_PANNED.connect(play_panned)
	print("Audionav player setup completed.")
	

func play_panned(audiostream: AudioStream, gainL: float, gainR: float, gainF: float, gainB: float) -> void:	
	print("Playing ", audiostream, " to Left", linear_to_db(gainL), ", to Right", linear_to_db(gainR), ", to Front", linear_to_db(gainF), " and to Back", linear_to_db(gainB))
	var playbackL: AudioStreamPlaybackPolyphonic = get_node("player_left").get_stream_playback()
	playbackL.play_stream(audiostream, 0, linear_to_db(gainL), 1, 0, "AudionavLeft");
	
	var playbackR: AudioStreamPlaybackPolyphonic = get_node("player_right").get_stream_playback()
	playbackR.play_stream(audiostream, 0, linear_to_db(gainR), 1, 0, "AudionavRight");
	
	var playbackF: AudioStreamPlaybackPolyphonic = get_node("player_front").get_stream_playback()
	playbackF.play_stream(audiostream, 0, linear_to_db(gainF), 1, 0, "AudionavFront");
	
	var playbackB: AudioStreamPlaybackPolyphonic = get_node("player_back").get_stream_playback()
	playbackB.play_stream(audiostream, 0, linear_to_db(gainB), 1, 0, "AudionavBack");
	#var playbackL: AudioStreamPlaybackPolyphonic = get_node("player_left").get_stream_playback()
	#playbackL.play_stream(audiostream, 0, gainL, 1, 0, "AudionavLeft");
	#
	#var playbackR: AudioStreamPlaybackPolyphonic = get_node("player_right").get_stream_playback()
	#playbackR.play_stream(audiostream, 0, gainR, 1, 0, "AudionavRight");
	#
	#var playbackF: AudioStreamPlaybackPolyphonic = get_node("player_front").get_stream_playback()
	#playbackF.play_stream(audiostream, 0, gainF, 1, 0, "AudionavFront");
	#
	#var playbackB: AudioStreamPlaybackPolyphonic = get_node("player_back").get_stream_playback()
	#playbackB.play_stream(audiostream, 0, gainB, 1, 0, "AudionavBack");

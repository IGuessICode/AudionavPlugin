class_name AudionavProfile
extends Resource
## Player audio offset data. Saved/Loaded by AudioNav Manager. Used to corrently pan sound effect to position

@export var AudionavLeft: Dictionary = { # @export so it can be recalled from plugin load script
	"name": "AudionavLeft",
	"volume_db": 0.0,
	"send": "Master",
	"panning_enabled": true,
	"pan": -1,
	"reverb_enabled": false,
}
@export var AudionavRight: Dictionary = {
	"name": "AudionavRight",
	"volume_db": 0.0,
	"send": "Master",
	"panning_enabled": true,
	"pan": -1,
	"reverb_enabled": false,
}
@export var AudionavFront: Dictionary = {
	"name": "AudionavFront",
	"volume_db": 0.0,
	"send": "Master",
	"panning_enabled": true,
	"pan": -1,
	"reverb_enabled": true,
	"room_size": 0.1,
	"damping": 0.05,
	"spread": 0.2,
	"wet": 0.2,
	"predelay_msec": 0
}
@export var AudionavBack: Dictionary = {
	"name": "AudionavBack",
	"volume_db": 0.0,
	"send": "Master",
	"panning_enabled": true,
	"pan": -1,
	"reverb_enabled": true,
	"room_size": 0.1,
	"damping": 0.1,
	"spread": 1,
	"wet": 0.5,
	"predelay_msec": 80
}

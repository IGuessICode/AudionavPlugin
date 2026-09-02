class_name KeySoundPreset
extends Resource
## FX resource, saves the values determined by developer in Key Sound menu

# Names determined by dev. These are some examples.
enum KEY_SOUND_PRESET_NAME {
	SETUP_SOUND,
	COLLECTABLE,
	ENEMY,
	HAZARD
}

@export var type: KEY_SOUND_PRESET_NAME # Associates preset with a designated object for cohesion: Collectable, Hazard, Enemy...
@export var audio_sample: AudioStream # Audio resource to play. Recommended 1-4s length
@export_range(-30, 20) var volume: float = 0 # Adjust sample level by devs standards [dB]
# Modifiers to introduce diversity inside a same KEY_SOUND_TYPE.
@export_range(0.0, 5.0, 0.02) var pitch_scale: float = 1.0
@export_range(0.0, 1.0, 0.01) var pitch_randomness: float = 0.0 # Pitch is modified randomly from AudioNav Manager

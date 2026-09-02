extends Node
class_name TTSComponent

@export var tts_nodes: Array[TTSData]
var tts_runtime_nodes: Array[TTSData]
@export_multiline var introduction: String
@export var start_automatically: bool
var introduction_played: bool

func _ready() -> void:
	for data: TTSData in tts_nodes:
		var node: Control = get_node(data.target)
		node.focus_entered.connect(on_node_focused.bind(data))
	
	if start_automatically:
		start()


func start():
	if introduction == "":
		introduction_played = true
		return
		
	NvdaWrapper.say(introduction)
	
	await get_tree().process_frame
	introduction_played = true


func on_node_focused(_data: TTSData):
	if not introduction_played:
		return
	
	NvdaWrapper.say(_data.description)


func add_tts_node(_target: Control, _description: String, _detailed_description: String = ""):
	if _has_tts_node(_target):
		return
	
	var new_data = TTSData.new()
	new_data.target = _target.get_path()
	new_data.description = _description
	new_data.detailed_description = _detailed_description
	
	tts_runtime_nodes.append(new_data)
	_target.focus_entered.connect(on_node_focused.bind(new_data))
	

func _has_tts_node(_target: Control) -> bool:
	var exists_node: bool = false
	
	for data: TTSData in tts_runtime_nodes:
		if get_node(data.target) == _target:
			exists_node = true
			break
			
	return exists_node


func _find_tts_node(_target: Control) -> TTSData:
	for data: TTSData in tts_runtime_nodes:
		if get_node(data.target) == _target:
			return data
			
	return null


func read_details(_target: Control):
	#print("Reading details from ", _target.name)
	var target_data = _find_tts_node(_target)
	#print(target_data)
	
	if target_data != null:
		NvdaWrapper.say(target_data.detailed_description)
	

#func update_details(_target: Control, _new_description: String):
	#var target_data = _find_tts_node(_target)
	#
	#if target_data != null:
		#target_data.detailed_description = _new_description

@tool
class_name KeysoundEffectArea
extends Node2D

var area_colour: Color = Color(0.85490197, 0.64705884, 0.1254902, 0.6) # Color DARK_GOLDENROD from Godot
var line_width: float = 2.0

func _enter_tree() -> void:
	# Effect area should only be visible in Editor mode.
	if not Engine.is_editor_hint():
		self.visible = false
	else: 
		self.visible = true

func _process(_delta: float) -> void:
	# In Editor mode, redraw the area in each "load"
	if Engine.is_editor_hint():
		queue_redraw()

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	draw_circle(get_parent().get_parent().position, get_parent().emission_radius, area_colour)
	

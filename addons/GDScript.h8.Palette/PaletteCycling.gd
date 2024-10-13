@tool
extends Node

const PALETTE_IDX := "paletteIdx"
var _material : ShaderMaterial = null

@export var canvas_item : CanvasItem
@export var scroll_rate : float

func _ready():
	pass

func _process(delta: float) -> void:
	if canvas_item != null:
		_material = canvas_item.material as ShaderMaterial
	if _material != null:
		var delta_y = scroll_rate * delta
		var palette_y = _material.get_shader_param(PALETTE_IDX)
		palette_y = fmod(palette_y.as_float() + delta_y, 1.0)
		_material.set_shader_param(PALETTE_IDX, palette_y)

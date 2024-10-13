@tool
extends EditorPlugin

var _imagePaletteDock

func _edit(object):
	if object is Texture:
		var texture = object as Texture2D
		_imagePaletteDock.set_source_texture(texture)

func _handles(object):
	return object is Texture2D

func _enter_tree():
	var scene = load("res://addons/GDScript.h8.Palette/ImagePaletteDock.tscn")
	_imagePaletteDock = scene.instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_UR, _imagePaletteDock)
	pass

func _exit_tree():
	remove_control_from_docks(_imagePaletteDock)
	_imagePaletteDock.free()
	pass

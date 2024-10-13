@tool
extends Control

# Properties
@export var SourceTextureRect : TextureRect
@export var IndexMapRect : TextureRect
@export var PaletteRect : TextureRect
@export var ClearPalette : Button
@export var ExtractPalette : Button
@export var ExtractIndexMap : Button
@export var SaveMap : Button 
@export var SavePalette: Button

var imagePalette
var indexMap

func _ready():
	# Connect signals
	ClearPalette.pressed.connect(on_clear_palette)
	ExtractPalette.pressed.connect(on_extract_palette)
	ExtractIndexMap.pressed.connect(on_extract_index_map)
	SaveMap.pressed.connect(on_save_map)
	SavePalette.pressed.connect(on_save_palette)

func on_save_palette():
	if ImagePalette == null:
		show_dialog("Drag Image Palette texture2d or Extract first.")
		return
	
	var path = SourceTextureRect.texture.resource_path.get_basename()
	var image = ImagePaletteExtensions.create_image(imagePalette)
	image.save_png(path + "_palette.png")
	EditorInterface.get_resource_filesystem().scan()

func on_save_map():
	if indexMap == null:
		show_dialog("Extract Index Map first.")
		return
	
	var path = SourceTextureRect.texture.resource_path.get_basename()
	indexMap.image.save_png(path + "_imap.png")
	EditorInterface.get_resource_filesystem().scan()

func on_extract_index_map():
	if SourceTextureRect.texture == null:
		show_dialog("Select Source texture2d for edit in file tree.")
		return

	if ImagePalette == null:
		show_dialog("Drag Image Palette texture2d or Extract first.")
		return

	indexMap = IndexMap.new() if indexMap == null else indexMap
	indexMap.map(SourceTextureRect.texture, imagePalette)
	IndexMapRect.texture = ImageTexture.create_from_image(indexMap.image)

func on_extract_palette():
	if SourceTextureRect.texture == null:
		show_dialog("Select Source texture2d for edit in file tree.")
		return

	imagePalette = ImagePalette.create_palette_from_texture(SourceTextureRect.texture)
	PaletteRect.texture = ImagePaletteExtensions.create_texture(imagePalette)

func on_clear_palette():
	PaletteRect.texture = null
	imagePalette = null

func set_source_texture(texture: Texture2D) -> void:
	SourceTextureRect.texture = texture

func _drop_data(at_position: Vector2, data):
	var file = get_file(data)
	if file == null:
		return

	var texture = ResourceLoader.load(file)
	imagePalette = ImagePalette.create_palette_from_texture(texture)
	PaletteRect.texture = texture

func _can_drop_data(at_position: Vector2, data) -> bool:
	return is_texture(data)

func show_dialog(message: String) -> void:
	var dialog = AcceptDialog.new()
	dialog.title = "Warning"
	dialog.dialog_text = message
	add_child(dialog)
	dialog.owner = self
	dialog.popup_centered()

func is_texture(data) -> bool:
	var file = get_file(data)
	return EditorInterface.get_resource_filesystem().get_file_type(file).contains("Texture2D") if file != null else false

func get_file(data):
	var dic = data.as_dictionary()
	if dic == null:
		return null

	var files = dic["files"].as_array()
	if files == null or files.size() != 1:
		return null

	return files[0]

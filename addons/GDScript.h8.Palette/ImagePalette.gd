class_name ImagePalette
var PaletteName: String
var ColorsInPalette: Array
var defaultColorName: String = "Color"

func get_count():
	return ColorsInPalette.size()

func get_color(index: int) -> Color:
	return ColorsInPalette[index].color

func set_color(index: int, color: Color) -> void:
	ColorsInPalette[index].color = color

func _init(paletteName: String = "RBPalette"):
	PaletteName = paletteName
	ColorsInPalette = []

func _initFrom(paletteToCopy: ImagePalette):
	PaletteName = paletteToCopy.PaletteName
	ColorsInPalette = paletteToCopy.ColorsInPalette.duplicate()

func add_color(color: Color) -> void:
	ColorsInPalette.append(PaletteColor.new(color, defaultColorName + str(ColorsInPalette.size())));

func remove_color_at_index(index: int) -> void:
	ColorsInPalette.remove_at(index)

func contains_color(colorToFind: Color) -> bool:
	return index_of(colorToFind) >= 0

func index_of(colorToFind: Color) -> int:
	for i in range(ColorsInPalette.size()):
		if is_zero_approx(colorToFind.a) and is_zero_approx(ColorsInPalette[i].color.a) or ColorsInPalette[i].color.is_equal_approx(colorToFind):
			return i
	return -1

static func create_palette_from_texture(sourceTexture: Texture) -> ImagePalette:
	var sourcePixels = sourceTexture.get_image()
	var palette = ImagePalette.new()
	palette.PaletteName = sourceTexture.get_path().get_basename()
	for i in range(sourcePixels.get_width()):
		for j in range(sourcePixels.get_height()):
			var colorAtSource = clear_rgb_if_no_alpha(sourcePixels.get_pixel(i, j))
			if not palette.contains_color(colorAtSource):
				palette.add_color(colorAtSource)
	
	return palette

static func clear_rgb_if_no_alpha(colorToClear: Color) -> Color:
	var clearedColor = colorToClear
	if clearedColor.a == 0.0:
		clearedColor = Color(0, 0, 0, 0)
	return clearedColor

func to_string() -> String:
	var fullString = "[RBPalette: Name=" + PaletteName + " Count=" + str(get_count()) + " Colors="
	for i in range(ColorsInPalette.size()):
		var colorString = "{" + str(ColorsInPalette[i].Color) + "}"
		fullString += colorString
	
	return fullString

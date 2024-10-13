class_name IndexMap

var image: Image
var width: int
var height: int

func map(sourceTexture: Texture, basePalette: ImagePalette) -> void:
	width = sourceTexture.get_width()
	height = sourceTexture.get_height()

	var sourcePixels : Image = sourceTexture.get_image()
	image = Image.create(width, height, false, Image.FORMAT_RGBA8)

	for i in range(width):
		for j in range(height):
			var curentColor := sourcePixels.get_pixel(i, j)

			var paletteIndex := basePalette.index_of(curentColor)
			if paletteIndex < 0:
				var coordinateFromBottomLeft := Vector2(i, j)
				var errorMsg := "Encountered color in source PaletteMap image that is not in the base palette. Color in PaletteMap: " + str(curentColor) + " At coordinate: " + str(coordinateFromBottomLeft)
				assert(false, errorMsg)
				pass

			var scale: float
			if basePalette.get_count() == 1:
				scale = 0.0
			else:
				scale = float(paletteIndex) / (basePalette.get_count() - 1)
				scale = clamp(scale, 0.0, 0.99)

			image.set_pixel(i, j, Color(scale, scale, scale, curentColor.a))

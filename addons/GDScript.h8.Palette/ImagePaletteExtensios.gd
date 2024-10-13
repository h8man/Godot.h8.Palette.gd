class_name ImagePaletteExtensions

static func create_image(palette: ImagePalette) -> Image:
	var image: Image = Image.create_empty(palette.get_count(), 1, false, Image.FORMAT_RGBA8)

	for i in range(palette.get_count()):
		image.set_pixel(i, 0, palette.get_color(i))

	return image

static func create_texture(palette: ImagePalette) -> Texture:
	return ImageTexture.new().create_from_image(create_image(palette))

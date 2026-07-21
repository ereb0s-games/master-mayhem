extends TextureRect

var canvas_size = Vector2i(32, 32)
var image: Image
var image_texture: ImageTexture
var current_color = Color.BLACK

func _ready():
	# Create a blank image
	image = Image.create(canvas_size.x, canvas_size.y, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0)) # Transparent background
	
	image_texture = ImageTexture.create_from_image(image)
	texture = image_texture

func _gui_input(event):
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			draw_pixel(get_local_mouse_position())
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			image.set_pixelv(get_local_mouse_position(), Color(0,0,0,0))

func draw_pixel(pos: Vector2):
	# Convert local mouse position to pixel coordinates
	var pixel_pos = Vector2i(pos / (size / Vector2(canvas_size)))
	
	if pixel_pos.x >= 0 and pixel_pos.x < canvas_size.x and \
	   pixel_pos.y >= 0 and pixel_pos.y < canvas_size.y:
		image.set_pixelv(pixel_pos, current_color)
		
		# Update the texture to show the new pixel
		image_texture.update(image)

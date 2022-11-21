extends PanelContainer

var imageData: NodeImage

var resizingRight: bool = false
var resizingBottom: bool = false
var previousSize: Vector2
var resizeClickPosition: Vector2

func _ready():
	if imageData:
		loadImage(imageData.imagePath)
		custom_minimum_size = imageData.nodeSize

func _process(_delta):
	if resizingRight:
		custom_minimum_size.x = previousSize.x + (get_global_mouse_position().x - resizeClickPosition.x)
		imageData.nodeSize = custom_minimum_size
		
	if resizingBottom:
		custom_minimum_size.y = previousSize.y + ( get_global_mouse_position().y - resizeClickPosition.y)
		imageData.nodeSize = custom_minimum_size

func _on_button_pressed():
	$TextureRect.grab_focus()
	$ImageFileDialog.position = get_viewport_rect().size / 2
	$ImageFileDialog.popup()

func _on_image_file_dialog_file_selected(path):
	loadImage(path)
	custom_minimum_size = $TextureRect.texture.get_size() / 4
	
func loadImage(path):
	$AddImageButton.size_flags_horizontal = SIZE_SHRINK_BEGIN
	$AddImageButton.size_flags_vertical = SIZE_SHRINK_BEGIN
	
	imageData.imagePath = path
	
	var image = Image.new()
	image.load(imageData.imagePath)
	var texture = ImageTexture.new()
	texture.set_image(image)
	
	$TextureRect.texture = texture


	

func _on_bottom_edge_gui_input(event):
	if event.is_action_pressed("mouseLeft"):
		resizingBottom = true
		previousSize = custom_minimum_size
		resizeClickPosition = get_global_mouse_position()
	if event.is_action_released("mouseLeft"):
		resizingBottom = false

func _on_right_edge_gui_input(event):
	if event.is_action_pressed("mouseLeft"):
		resizingRight = true
		previousSize = custom_minimum_size
		resizeClickPosition = get_global_mouse_position()
	if event.is_action_released("mouseLeft"):
		resizingRight = false	










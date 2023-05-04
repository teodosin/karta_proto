extends PanelContainer

var imageData: OperatorCrop
var aspect: float = 1.0 # height / width

var readyToLoad := false

var resizingRight: bool = false
var resizingBottom: bool = false
var previousSize: Vector2
var resizeClickPosition: Vector2

func _ready():
	if imageData:
		readyToLoad = true
		
	


func _process(_delta):
	if readyToLoad:
		custom_minimum_size = imageData.nodeSize
		readyToLoad = false		
	
	if resizingRight:
		custom_minimum_size.x = previousSize.x + (get_global_mouse_position().x - resizeClickPosition.x)
		
		custom_minimum_size.y = custom_minimum_size.x / aspect
		imageData.updateSize(custom_minimum_size)
		
	if resizingBottom:
		custom_minimum_size.y = previousSize.y + (get_global_mouse_position().y - resizeClickPosition.y)
		custom_minimum_size.x = custom_minimum_size.y * aspect
		imageData.updateSize(custom_minimum_size)


func loadImage(path):

	imageData.loadImage()
	
	var texture = ImageTexture.new()
	texture.set_image(imageData.imageResource)
	
	if texture.get_size() > Vector2(1,1):
		aspect = texture.get_size().x / texture.get_size().y
	
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










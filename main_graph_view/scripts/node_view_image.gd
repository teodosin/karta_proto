extends TextureRect

var imageData: NodeImage

var aspect: float = 1.0 # height / width
var aspectUpdater: Callable 

var readyToLoad := false

var previousSize: Vector2
var resizeClickPosition: Vector2

func setAspectUpdater(function: Callable):
	aspectUpdater = function

func _ready():
	if imageData:
		readyToLoad = true


func _process(_delta):
	if readyToLoad:
		loadImage(imageData.imagePath)
		get_parent().custom_minimum_size = imageData.nodeSize
		readyToLoad = false		
	
func _on_button_pressed():
	grab_focus()	
	$ImageFileDialog.size.y = 400
	
	$ImageFileDialog.position = get_viewport_rect().size / 2 - Vector2($ImageFileDialog.size / 2)

	$ImageFileDialog.popup()

func _on_image_file_dialog_file_selected(path):
	loadImage(path)
	get_parent().custom_minimum_size = self.texture.get_size()
	
func loadImage(path):
	$AddImageButton.size_flags_horizontal = SIZE_SHRINK_BEGIN
	$AddImageButton.size_flags_vertical = SIZE_SHRINK_BEGIN
	
	imageData.updatePath(path)
	
	imageData.loadImage()
	
	var newTexture = ImageTexture.new()
	newTexture.set_image(imageData.imageResource)
	
	if newTexture.get_size() > Vector2(1,1):
		if aspectUpdater != null:
			aspect = newTexture.get_size().x / newTexture.get_size().y
			aspectUpdater.call(aspect)
	
	self.texture = newTexture








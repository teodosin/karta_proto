extends NodeViewBase

var aspect: float = 1.0 # height / width

var readyToLoad := false

func _ready():
	if typeData:
		assert(typeData is NodeImageData)
		readyToLoad = true
		
	spawnSelf()


func _process(_delta):
	baseProcess()
	
	if readyToLoad:
		loadImage(typeData.imagePath)
		custom_minimum_size = typeData.nodeSize
		readyToLoad = false		

func _on_button_pressed():
	$TextureRect.grab_focus()	
	$ImageFileDialog.size.y = 400
	
	$ImageFileDialog.position = get_viewport_rect().size / 2 - Vector2($ImageFileDialog.size / 2)

	$ImageFileDialog.popup()

func _on_image_file_dialog_file_selected(path):
	loadImage(path)
	custom_minimum_size = $TextureRect.texture.get_size() / 4
	
func loadImage(path):
	$AddImageButton.size_flags_horizontal = SIZE_SHRINK_BEGIN
	$AddImageButton.size_flags_vertical = SIZE_SHRINK_BEGIN
	
	typeData.imagePath = path
	
	var image = Image.new()
	image.load(typeData.imagePath)
	var texture = ImageTexture.new()
	texture.set_image(image)
	
	if texture.get_size() > Vector2(1,1):
		aspect = texture.get_size().x / texture.get_size().y
	
	$TextureRect.texture = texture


func _on_gui_input(event):
	on_self_input(event)

class_name NodeImage
extends NodeTypeData

@export var nodeId: int
@export var nodeSize: Vector2
@export var imagePath: String

var imageResource: Image

func _init(
	tid: int = 0, 
	tsize: Vector2 = Vector2.ZERO, 
	tpath: String = ""
	):
		
	self.nodeId = tid
	self.nodeSize = tsize
	self.imagePath = tpath
	
	loadImage()

func updateSize(newSize: Vector2):
	nodeSize = newSize
	
func updatePath(newPath: String):
	imagePath = newPath

func loadImage():
#	updatePath(path)
	if !FileAccess.file_exists(imagePath):
		return
	else:
		var image = Image.new()
		image.load(imagePath)
		setImageResource(image)

func setImageResource(image: Image):
	imageResource = image

func getImageResource() -> Image:
	return imageResource

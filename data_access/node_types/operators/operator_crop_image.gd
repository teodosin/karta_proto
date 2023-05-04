class_name OperatorCrop
extends BaseOperator

@export var nodeId: int
@export var nodeSize: Vector2

#@export var imagePath: String

@export var cropArea: Rect2i
var imageResource: Image

@export var sockets: Array #InputSocket

var socketsTemplate: Array = [
	InputSocket.new()
]

func getSockets():
	pass
	
func isEdgeInSockets(edgeId: int) -> bool:
	var result = sockets.find(edgeId)
	if result == -1:
		return false
	else:
		return true

func _init(
	tid: int = 0, 
	tsize: Vector2 = Vector2.ZERO, 
#	tpath: String = "",
	
	tcropArea: Rect2i = Rect2i(Vector2i.ZERO, Vector2i(50, 50)),
	
	tsockets: Array = socketsTemplate
	):
		
	self.nodeId = tid
	self.nodeSize = tsize
#	self.imagePath = tpath

	self.cropArea = tcropArea
	
	self.sockets = tsockets

func updateSize(newSize: Vector2):
	nodeSize = newSize
	
#func updatePath(newPath: String):
#	imagePath = newPath

func updateCropArea():
	if sockets[0].connections.is_empty():
		return
	pass

func execute(dataAccess: DataAccess):
	if sockets[0].connections.is_empty():
		return
	elif !sockets[0].connections[0].has("imageResource"):
		print("Invalid input node: no ImageResource found")
		return
		
	else:
		imageResource = dataAccess.getNode(sockets[0].connections[0]).imageResource.get_region(cropArea)

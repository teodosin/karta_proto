class_name NodeImageData

var nodeId: int
var nodeSize: Vector2
var imagePath: String

func _init(
	tid: int, 
	tsize: Vector2, 
	tpath: String
	):
		
	self.nodeId = tid
	self.nodeSize = tsize
	self.imagePath = tpath

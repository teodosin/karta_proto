class_name NodeImage

var nodeId: int
var nodeSize: Vector2
var imagePath: String

func _init(tid, tsize, tpath):
	self.nodeId = tid
	self.nodeSize = tsize
	self.imagePath = tpath

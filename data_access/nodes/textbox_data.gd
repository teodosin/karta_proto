extends Resource
class_name NodeTextData

# var nodeId: int
var nodeSize: Vector2
var nodeText: String

func _init(
	# tid: int, 
	tsize: Vector2 = Vector2(200, 100), 
	ttext: String = ""
	):
		
	# self.nodeId = tid
	self.nodeSize = tsize
	self.nodeText = ttext

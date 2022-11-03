class_name NodeBase

var id: int
var name: String
var position: Vector2
var relatedNodes = {}


func _init(id: int, name: String, position: Vector2):
	self.id = id
	self.name = name
	self.position = position
	
	
func addRelatedNode(relatedNode: RelatedNode):
	relatedNodes[relatedNode.id] = relatedNode

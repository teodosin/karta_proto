class_name NodeBase

var id: int
var name: String
var relatedNodes = {}


func _init(id: int, name: String):
	self.id = id
	self.name = name
	self.relatedNodes = {}
	
	
func getRelatedNode(relatedId: int) -> RelatedNode: 
	assert(relatedNodes.has(relatedId), "ERROR related node not found")
	return relatedNodes[relatedId]
	
	
func addRelatedNode(relatedNode: RelatedNode):
	relatedNodes[relatedNode.id] = relatedNode
	
	
func updateRelatedNode(id: int, position: Vector2):
	assert(relatedNodes.has(id), "ERROR related node not found")
	var relatedNode: RelatedNode = relatedNodes[id]
	relatedNode.relativePosition = position

class_name DataAccess

func addNode(_nodeType: String) -> NodeBase:
	return null
	
func getNode(_id: int) -> NodeBase: 
	return null
	
func updateRelatedNodePosition(_id: int, _relatedId: int, _selfPosition: Vector2, _relatedPosition: Vector2):
	pass
	
func addRelatedNode(_id: int, _relatedId: int, _selfPosition: Vector2, _relatedPosition: Vector2):
	pass
	
func addEdge(_fromId: int, _toId: int):
	pass
	
func getAllRelatedEdges(_id: int) -> Array[EdgeBase]:
	return [] 

class_name DataAccess

func addNode() -> NodeBase:
	return null
	
func getNode(id: int) -> NodeBase: 
	return null
	
func updateRelatedNodePosition(id: int, relatedId: int, position: Vector2):
	pass
	
func addRelatedNode(id: int, relatedId: int, relatedPosition: Vector2):
	pass
	
func addWire(fromId: int, toId: int):
	pass
	
func getAllRelatedWires(id: int) -> Array[WireBase]:
	return [] 

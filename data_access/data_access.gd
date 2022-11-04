class_name DataAccess

func addNode(position: Vector2):
	pass
	
func getNode(id: int) -> NodeBase: 
	return null
	
func updateNodePosition(id: int, position: Vector2):
	pass
	
func addRelatedNode(id: int, relatedId: int, relatedPosition: Vector2):
	pass
	
func addWire(fromId: int, toId: int):
	pass
	
func getAllWires(): 
	pass

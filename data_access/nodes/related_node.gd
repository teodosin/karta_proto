class_name RelatedNodeData
extends Resource

var id: int
var relativePosition: Vector2

var relativeSize: Vector2 = Vector2(1.0, 1.0)
var relativeRotation: float = 0.0
var relativeZDepth: int = 0

var expanded: bool

func _init(
		r_id: int, 
		r_relpos: Vector2 = Vector2.ZERO, 
		r_expanded: bool = false
		):
			
	self.id = r_id
	self.relativePosition = r_relpos
	self.expanded = r_expanded

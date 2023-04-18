extends Resource
class_name RelatedNodeData

@export var id: int
@export var relativePosition: Vector2

@export var relativeSize: Vector2 = Vector2(1.0, 1.0)
@export var relativeRotation: float = 0.0
@export var relativeZDepth: int = 0

@export var expanded: bool

func _init(
		r_id: int, 
		r_relpos: Vector2 = Vector2.ZERO, 
		r_expanded: bool = false
		):
			
	self.id = r_id
	self.relativePosition = r_relpos
	self.expanded = r_expanded

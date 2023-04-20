class_name RelatedNode
extends Resource

@export var id: int
@export var relativePosition: Vector2

#Unused for now
@export var relativeSize: Vector2 = Vector2(1.0, 1.0)
@export var relativeRotation: float = 0.0
@export var relativeZDepth: int = 0

@export var expanded: bool

func _init(
		r_id: int = 0, 
		r_relpos: Vector2 = Vector2.ZERO, 
		
		relsize: Vector2 = Vector2(1.0, 1.0),
		relrot: float = 0.0,
		relz: int = 0,
		
		r_expanded: bool = false
		):
			
	self.id = r_id
	self.relativePosition = r_relpos
	
	relativeSize = relsize
	relativeRotation = relrot
	relativeZDepth = relz
	self.expanded = r_expanded

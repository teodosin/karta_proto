class_name ObjectRectangle
extends Node2D

@export var nodeId: int
@export var pos: Vector2
@export var size: Vector2
@export var rot: float
@export var color: Color


func getExportedProperties():
	var props = [
		"nodeId",
		"pos",
		"size",
		"rot",
		"color"
	]
	return props

func _init(
	t_id: int = 0, 
	t_pos: Vector2 = Vector2.ZERO,
	t_size: Vector2 = Vector2.ZERO,
	t_rot: float = 0.0,
	t_col: Color = Color(1.0, 1.0, 0.0, 0.7),
	):
		
	self.nodeId = t_id
	self.pos = t_pos
	self.size = t_size
	self.rot = t_rot
	self.color = t_col
	
func _ready():
	var tweener = create_tween()
	
func _process(_delta):
	queue_redraw()
	
func _draw():
	draw_rect(Rect2(pos, size), color, true)


func setPosition(newPos: Vector2):
	self.pos = newPos
	
func setSize(newSz: Vector2):
	self.size = newSz
	
func setCol(col: Color):
	self.color = col
	
func despawn():
	var tweener = create_tween()
	
	tweener.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.7)
	tweener.set_ease(Tween.EASE_IN)
	tweener.tween_callback(deleteSelf)
		# Also remove the node from the array of references
func deleteSelf():
	get_parent().remove_child(self)
	queue_redraw()
	self.queue_free()	

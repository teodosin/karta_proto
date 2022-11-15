class_name WireViewBase
extends Node2D

var id: int 
var source: NodeViewBase
var target: NodeViewBase

var sourcePos: Vector2
var targetPos: Vector2

func _process(_delta):
	if !is_instance_valid(source) or !is_instance_valid(target):
		print("WIRE DESPAWNED: " + str(id))
		get_parent().remove_child(self)
		self.queue_free()
	
	if is_instance_valid(source):
		sourcePos = source.getPositionCenter()
	
	if is_instance_valid(target):
		targetPos = target.getPositionCenter()
	
	queue_redraw()
func _draw():
	if source.isFocal or target.isFocal:
		draw_line(
			sourcePos, 
			targetPos, Color.YELLOW, 0.5 * source.fadeOut * target.fadeOut, true
		)
	else:
		draw_line(
			sourcePos, 
			targetPos, Color.YELLOW, 2.0 * source.fadeOut * target.fadeOut, true
		)

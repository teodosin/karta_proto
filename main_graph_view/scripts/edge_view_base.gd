class_name EdgeViewBase
extends Node2D

var id: int 
var source: NodeViewBase
var target: NodeViewBase

var sourcePos: Vector2
var targetPos: Vector2

func _ready():
	$EdgeGroupLabel.text = "Wier"

func _process(_delta):
	if !is_instance_valid(source) or !is_instance_valid(target):
		var despawnTween = create_tween()
		despawnTween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
		despawnTween.tween_callback(deleteSelf)

	
	if is_instance_valid(source):
		sourcePos = source.getPositionCenter()
	
	if is_instance_valid(target):
		targetPos = target.getPositionCenter()
		
		if target.dataNode.typeData.has_method("isEdgeInSockets"): 
			if target.dataNode.typeData.isEdgeInSockets(id):
				targetPos = target.socket.position

	$EdgeGroupLabel.global_position = sourcePos + targetPos / 2
	
	queue_redraw()
	#self.global_position = sourcePos + (targetPos / 2)
	
func deleteSelf():
	get_parent().remove_child(self)
	self.queue_free()	

func getDistanceToEdge(mouse_position: Vector2, A: Vector2, B: Vector2) -> float:
	var AB = B - A
	var BE = mouse_position - B
	var AE = mouse_position - A

	var AB_BE = AB.dot(BE)
	var AB_AE = AB.dot(AE)

	var reqAns = 0.0

	if AB_BE > 0:
		reqAns = B.distance_to(mouse_position)
	elif AB_AE < 0:
		reqAns = A.distance_to(mouse_position)
	else:
		reqAns = abs(AB.x * AE.y - AB.y * AE.x) / AB.length()

	return reqAns

func _draw():

		
	
	if is_instance_valid(target) and is_instance_valid(source):

		if source.mouseHovering == false and target.mouseHovering == false and getDistanceToEdge(get_global_mouse_position(), source.getPositionCenter(), target.getPositionCenter()) < 10.0:
			draw_line(
				sourcePos, 
				targetPos, Color(0.5,0.5,0.5), 1.5, true
			)	
		
		elif source.getIsPinnedToFocal() or target.getIsPinnedToFocal():
			draw_line(
				sourcePos, 
				targetPos, Color(0.4,0.2,0.3), 0.05, true
			)	
		else:
			draw_line(
				sourcePos, 
				targetPos, Color(0.4,0.2,0.3), 2.0, true
			)

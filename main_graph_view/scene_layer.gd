extends CanvasLayer

var sceneObjectRectangle = load("res://data_access/node_types/objects/object_rectangle.tscn")

@onready var imageOutputTexture = $OutputTexture

@onready var viewportContainer = $ViewportContainer
@onready var viewport = $ViewportContainer/SubViewport

enum OutputStates {
	NONE,
	IMAGE,
	VIEWPORT
}

var activeOutput: OutputStates = OutputStates.NONE

# Functions for changing the current output state
func setOutputToImage():
	activeOutput = OutputStates.IMAGE
	
	viewportContainer.visible = false
	imageOutputTexture.visible = true
	
func setOutputToViewport(focal: NodeViewBase):
	if get_parent().activeTool == get_parent().ToolEnums.interactionModes.TRANSITION:
		return
	
	if focal.dataNode.nodeType != "SCENE":
		return
	
	activeOutput = OutputStates.VIEWPORT
	
	for chld in viewport.get_children():
		viewport.remove_child(chld)
		
	print("SETTING THE SCENE")
	
	if is_instance_valid(focal.dataNode):
#		var child = focal.dataNode.sceneData
#		viewport.add_child(child)
		addChildObjectsAsChildrenToViewport(focal.dataNode)
		pass
		
	imageOutputTexture.visible = false
	viewportContainer.visible = true
	
func transitionToViewport(from: NodeBase, to: NodeBase):
	if activeOutput != OutputStates.VIEWPORT:
		return
		
	var fromChildren: Array
	var toChildren: Array
	
	for chld in viewport.get_children():
		viewport.remove_child(chld)
	
	for edge in from.edges.values():
		var edgeObj: EdgeBase = get_parent().dataAccess.edges[edge]
		
		if edgeObj.edgeType == "PARENT" and edgeObj.sourceId == from.id:
			var obj = get_parent().dataAccess.nodes[edgeObj.getConnection(from.id).id]
			
			match obj.nodeType:
				"OBJECT_RECTANGLE":
					var rect = obj.objectData
					fromChildren.append(rect)
				_: 
					print("garble")
					
	for edge in to.edges.values():
		var edgeObj: EdgeBase = get_parent().dataAccess.edges[edge]
		
		if edgeObj.edgeType == "PARENT" and edgeObj.sourceId == to.id:
			var obj = get_parent().dataAccess.nodes[edgeObj.getConnection(to.id).id]
			
			match obj.nodeType:
				"OBJECT_RECTANGLE":
					var rect = obj.objectData
					toChildren.append(rect)
				_: 
					print("garble")
					
	print("Children from: " + str(fromChildren.size()))
	print("Children to: " + str(toChildren.size()))
	
	for i in fromChildren.size():
		if i >= toChildren.size():	
			break
		# I think it's better to tween brand new objects, so the originals 
		# don't get mutated
		var newRect = sceneObjectRectangle.instantiate()
		newRect.setPosition(fromChildren[i].pos)
		newRect.setSize(fromChildren[i].size)
		
		addChildToViewport(newRect)
		tweenChild(newRect, toChildren[i])
			

		
func tweenChild(from, to):
	if from.get_class() != to.get_class():
		print("incompatible classes")
		return
		
	var tween = create_tween()
	
	if from.has_method("getExportedProperties") and to.has_method("getExportedProperties"):
		print("Found exportable properties yo")
		for prop in from.getExportedProperties():
			print(prop)
			print(from.get(prop))
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.set_trans(Tween.TRANS_QUINT)
			#tween.set_parallel()
			tween.tween_property(from, prop, to.get(prop), 1.0)
	
func addChildObjectsAsChildrenToViewport(node: NodeBase):
	get_parent().dataAccess.loadNodeConnections(node.id)
	
	for edge in node.edges.values():
		var edgeObj: EdgeBase = get_parent().dataAccess.edges[edge]
		
		if edgeObj.edgeType == "PARENT" and edgeObj.sourceId == node.id:
			var obj = get_parent().dataAccess.nodes[edgeObj.getConnection(node.id).id]
			
			match obj.nodeType:
				"OBJECT_RECTANGLE":
					var rect = obj.objectData
					addChildToViewport(rect)
				_: 
					print("garble")
			
			get_parent().dataAccess.loadNodeConnections(edgeObj.getConnection(node.id).id)
			
	
func setOutputToNone():
	activeOutput = OutputStates.NONE
	
	imageOutputTexture.visible = false
	viewportContainer.visible = false
	
func setOutputFromFocal(focal: NodeViewBase):
	match focal.dataNode.nodeType:
		"IMAGE":
			setOutputToImage()
		"SCENE":
			setOutputToViewport(focal)
		_:
			setOutputToNone()
		
func setTexture(img: ImageTexture):
	imageOutputTexture.texture = img

func addChildToViewport(child: Node):
	viewport.add_child(child)	
func removeChildFromViewport(child: Node):
	viewport.remove_child(child)

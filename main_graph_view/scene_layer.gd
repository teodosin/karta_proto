extends CanvasLayer

var sceneObjectRectangle = load("res://data_access/node_types/objects/object_rectangle.tscn")

@onready var imageOutputTexture = $OutputTexture

@onready var viewportContainer = $ViewportContainer
@onready var viewport = $ViewportContainer/SubViewport/ScreenCenter

enum OutputStates {
	NONE,
	IMAGE,
	VIEWPORT
}

var activeOutput: OutputStates = OutputStates.NONE

func _process(_delta):
	viewport.position = get_viewport().size / 2

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
	
		
	# Initialise variable to store the from/to child pairs
	var childPairs: Dictionary
	
	# The following mess of loops is disgusting and should be cleaned up
	
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
	
	var pairSize: int = fromChildren.size()
	if toChildren.size() < fromChildren.size():
		pairSize = toChildren.size()
	
	var toIndex: int = 0
	for i in fromChildren.size():
		if i >= toChildren.size():	
			break
		if toChildren.has(fromChildren[i]):
				print("IT IS THA SAME")
				childPairs[fromChildren[i]] = fromChildren[i]
				print(childPairs)
		else:
			childPairs[fromChildren[i]] = toChildren[toIndex]
			toIndex += 1
	
	for chld in viewport.get_children():
		# Code that attempted to keep a rectangle if it is shared between states
#		if toChildren.has(chld):
#			continue
			
		viewport.remove_child(chld)
		
	for key in childPairs.keys():
		# I think it's better to tween brand new objects, so the originals 
		# don't get mutated
		
		# Second part of the code that wants to keep shared objects
#		if key == childPairs[key]:
#			continue
			
		var newRect = sceneObjectRectangle.instantiate()
		newRect.setPosition(key.pos)
		newRect.setSize(key.size)
		
		addChildToViewport(newRect)
		tweenChild(newRect, childPairs[key])
			

		
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
			tween.set_parallel()
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

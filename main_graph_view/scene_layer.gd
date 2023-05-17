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
	
func addChildObjectsAsChildrenToViewport(node: NodeBase):
	get_parent().dataAccess.loadNodeConnections(node.id)
	
	for edge in node.edges.values():
		var edgeObj: EdgeBase = get_parent().dataAccess.edges[edge]
		
		if edgeObj.edgeType == "PARENT" and edgeObj.sourceId == node.id:
			var obj = get_parent().dataAccess.nodes[edgeObj.getConnection(node.id).id]
			print("Found Child on the Scene of type: " + obj.nodeType)
			
			match obj.nodeType:
				"OBJECT_RECTANGLE":
					var rect = obj.objectData
					print("Adding rect to viewport")
					addChildToViewport(rect)
				_: 
					print("garble")
			
			get_parent().dataAccess.loadNodeConnections(edgeObj.getConnection(node.id).id)
			
	pass
	
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

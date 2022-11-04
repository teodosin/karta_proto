extends Node2D

@onready var nodeBaseTemplate = load("res://main_graph_view/nodes/node_view_base.tscn")

var focalNode: NodeViewBase = null
var nodeWireSource: NodeViewBase = null
var nodeHovering: NodeViewBase = null

var dataAccess: DataAccess = DataAccessInMemory.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	queue_redraw()

func _input(event):
	if event.is_action_pressed("createNewNode"):
		createNode(true)
	
	if event.is_action_released("mouseRight"):
		if nodeWireSource and nodeHovering:
			dataAccess.addWire(nodeWireSource.id, nodeHovering.id)
			print(nodeHovering.id)
		nodeWireSource = null
		nodeHovering = null
		
func createNode(atMouse: bool = false) -> NodeViewBase:
	var position: Vector2
	if atMouse: 
		position = get_global_mouse_position()
	else: 
		position = Vector2.ZERO
	var newNode = nodeBaseTemplate.instantiate()
	var newId = dataAccess.addNode(newNode.position)
	newNode.id = newId
	newNode.rightMousePressed.connect(self.handle_node_click.bind(newNode))
	newNode.mouseHovering.connect(self.handle_mouse_hover.bind(newNode))
	newNode.set_position(position)	
	if not focalNode:
		focalNode = newNode
	add_child(newNode)
	return newNode
	
	
func _draw():
	if nodeWireSource:
		draw_dashed_line(nodeWireSource.position, get_global_mouse_position(), 
						Color.WHITE, 1.0, 2.0)
		
# for now just draw all wires,
# once we add the logic for focal nodes, we will have to 
# select a subset of wires to draw (for example only
# between nodes that are related to focal node)  
	for w in dataAccess.getAllWires():
		var wire: WireBase = w
		var sourceNode: NodeBase = dataAccess.getNode(wire.sourceId)
		var targetNode: NodeBase = dataAccess.getNode(wire.targetId)
		draw_line(sourceNode.position, targetNode.position, Color.YELLOW, 2, true)	
		print(sourceNode.position, targetNode.position)	


func _on_add_button_pressed():
	if focalNode == null:
		focalNode = createNode()
		focalNode.position = get_viewport_rect().size / 2
	else: 
		var relatedNode = createNode()
		dataAccess.addWire(focalNode.id, relatedNode.id)
		
func handle_node_click(newNode):
	nodeWireSource = newNode	
func handle_mouse_hover(newNode):
	if nodeWireSource:
		nodeHovering = newNode
		

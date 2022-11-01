extends Node2D

@onready var node_base = load("res://main_graph_view/nodes/node_view_base.tscn")

var nodeInFocus: NodeViewBase = null

var data_access: DataAccess = DataAccessInMemory.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("createNewNode"):
		createNode(true)
		
		
func createNode(atMouse: bool = false) -> NodeViewBase:
	var newId = data_access.addNode()
	var newNode = node_base.instantiate()
	newNode.id = newId
	
	if atMouse:
		newNode.set_position(get_global_mouse_position())
		
	add_child(newNode)
	return newNode
	

func _on_add_button_pressed():
	if nodeInFocus == null:
		nodeInFocus = createNode()
		nodeInFocus.position = get_viewport_rect().size / 2
	else: 
		var relatedNode = createNode()
		data_access.addWire(nodeInFocus.id, relatedNode.id)
		
		
		
		

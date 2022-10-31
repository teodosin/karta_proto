extends Node2D

@onready var node_base = load("res://main_graph_view/nodes/node_base.tscn")
@onready var wire_base = load("res://main_graph_view/wires/wire_base.tscn")

var nodeInFocus: NodeBase = null

var data_access: DataAccess = DataAccessInMemory.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("createNewNode"):
		createNode()
		
		
func createNode() -> NodeBase:
	var newId = data_access.addNode()
	var newNode = node_base.instantiate()
	newNode.id = newId
	add_child(newNode)
	return newNode
	

func _on_add_button_pressed():
	if nodeInFocus == null:
		nodeInFocus = createNode()
		nodeInFocus.position = get_viewport_rect().size / 2
	else: 
		var relatedNode = createNode()
		data_access.addWire(nodeInFocus.id, relatedNode.id)
		
		
		
		

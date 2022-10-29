extends Node2D

@onready var node_base = load("res://main_graph_view/nodes/node_base.tscn")
@onready var wire_base = load("res://main_graph_view/wires/wire_base.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("create_new_node"):
		var newNode = node_base.instantiate()
		newNode.set_position(get_global_mouse_position())
		add_child(newNode)

extends PopupMenu

var thisNode: NodeViewBase

func setNodeContext(node: NodeViewBase):
	thisNode = node

func _ready():
	
	add_item("Expand Node", 1)
	
	# Commented this out to prevent accidental clicks
	#add_item("Delete Node")
	


func _on_index_pressed(index):
	get_parent().expandConnections(thisNode)

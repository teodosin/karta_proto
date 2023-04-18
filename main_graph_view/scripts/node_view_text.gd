extends NodeViewBase


var resizingRight: bool = false
var resizingBottom: bool = false
var previousSize: Vector2
var resizeClickPosition: Vector2

func _ready():
	if nodeData.typeData:
		assert(nodeData.typeData is NodeTextData)
		$VBoxContainer/TextEdit.text = nodeData.typeData.nodeText
		custom_minimum_size = nodeData.typeData.nodeSize

func _process(_delta):
	baseProcess()

func _on_text_edit_text_changed():
	nodeData.typeData.nodeText = $VBoxContainer/TextEdit.text


func _on_gui_input(event):
	on_self_input(event)

extends CanvasLayer

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
	activeOutput = OutputStates.VIEWPORT
	
	for chld in viewport.get_children():
		viewport.remove_child(chld)
	
	if is_instance_valid(focal.dataNode.gobjectData):
		var child = focal.dataNode.gobjectData
		viewport.add_child(child)
		
	imageOutputTexture.visible = false
	viewportContainer.visible = true
	
func setOutputToNone():
	activeOutput = OutputStates.NONE
	
	imageOutputTexture.visible = false
	viewportContainer.visible = false
	
func setOutputFromFocal(focal: NodeViewBase):
	match focal.dataNode.nodeType:
		"IMAGE":
			setOutputToImage()
		"GOBJECT":
			print("Hello I am a hideous gobject")
			setOutputToViewport(focal)
		_:
			setOutputToNone()
		
func setTexture(img: ImageTexture):
	imageOutputTexture.texture = img

func addChildToViewport(child: Node):
	viewport.add_child(child)	
func removeChildFromViewport(child: Node):
	viewport.remove_child(child)

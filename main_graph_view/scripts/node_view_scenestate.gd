extends SubViewportContainer

var imageData: NodeImage

func _ready():
	await RenderingServer.frame_post_draw
	imageData.setImageResource($SubViewport.get_texture().get_image())



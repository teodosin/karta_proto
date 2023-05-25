extends Panel

var mouseHovering: bool = false

func _on_mouse_entered():
	mouseHovering = true

func _on_mouse_exited():
	mouseHovering = false

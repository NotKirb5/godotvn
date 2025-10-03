extends Button


@onready var route = null

@onready var window = DisplayServer.window_get_size()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func settext(s:String)->void:
	text = s
	size = Vector2(window.x/3,window.y/3)
	#pivot_offset = Vector2(size.x/2,size.y/2)
	#await resized
	#global_position.x = window.x/2 - size.x/2

func setroute(r:String)->void:
	route = r


func _on_pressed() -> void:
	if route != null:
		get_tree().get_first_node_in_group('overlay').changebranch(route)


func sety(buttonoffset, idex)-> void:
	global_position.y = int(window.y/buttonoffset) * idex

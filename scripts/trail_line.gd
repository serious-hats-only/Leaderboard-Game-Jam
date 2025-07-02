extends Line2D

var previous_position: Vector2 = Vector2.ZERO
var businessman_half: float = 0.0

func _ready() -> void:
	var texture = get_parent().texture
	businessman_half = texture.get_size().x * 0.8 # started as .5 but I added a bit
	previous_position = get_parent().global_position

func _process(delta: float) -> void:
	var current_position = get_parent().global_position
	var direction = (current_position - previous_position).normalized()
	
	add_point(current_position - businessman_half * direction)
	if points.size() > 10:
		remove_point(0)
	
	previous_position = current_position

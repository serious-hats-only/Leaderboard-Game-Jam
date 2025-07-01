extends Area2D

@export var rotation_speed : float = 2.0 # speed while pressing Q
@export var snap_speed : float = 25.0 # speed of snapping back

var rotating : bool = false
var snapping : bool = false
var has_kicked : bool = false
var original_rotation : float = 0.0 # in radians
var final_rotation : float = -1.0 # in radians


func _ready() -> void:
	original_rotation = rotation


func _process(delta: float) -> void:
	if Input.is_action_pressed("kick"):
		rotating = true
		snapping = false
		rotation += rotation_speed * delta
		rotation = clamp(rotation, -2.0, 1.5)
	elif rotating:
		rotating = false
		snapping = true
	
	if snapping:
		rotation = lerp_angle(rotation, final_rotation, snap_speed * delta)
		if rotation < 1.0 and not has_kicked:
			Global.businessman_kicked.emit()
			has_kicked = true
		if abs(rotation - original_rotation) < 0.01:
			rotation = original_rotation
			snapping = false

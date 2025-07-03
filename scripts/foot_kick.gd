extends Area2D

@export var rotation_speed : float = -2.0 # speed while pressing Q
@export var snap_speed : float = 25.0 # speed of snapping back

var rotating : bool = false
var snapping : bool = false
var has_kicked : bool = false
var original_rotation : float = 0.0 # in radians
var final_rotation : float = 1.0 # in radians

@onready var static_businessman := get_node("/root/MainMenu/Path2D/PathFollow2D/Businessman")
@onready var animated_businessman := get_node("/root/MainMenu/Path2D/AnimatedBusinessman")

func _ready() -> void:
	original_rotation = rotation
	
	# Start with animation visible and static hidden
	animated_businessman.visible = true
	static_businessman.visible = false

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
		
		if rotation > 0.3 and not has_kicked:
			Global.businessman_kicked.emit()
			has_kicked = true

			# 👞 Hide the animated one and show the static one
			animated_businessman.visible = false
			static_businessman.visible = true

		if abs(rotation - original_rotation) < 0.01:
			rotation = original_rotation
			snapping = false

extends Camera2D

var shake_amount = 0.0
var shake_decay = 3.5
var original_offset := Vector2.ZERO

func _ready():
	original_offset = offset

func _process(delta):
	if shake_amount > 0:
		offset = original_offset + Vector2(
			randf_range(-1, 1),
			randf_range(-1, 1)
		) * shake_amount
		shake_amount = max(shake_amount - delta * shake_decay, 0)
	else:
		offset = original_offset

func start_shake(amount: float):
	shake_amount = amount

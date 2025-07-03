extends Area2D

@export var powerup_type: String = "mustard"
@export var duration: float = 5.0

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.apply_powerup("mustard", 5.0)
		queue_free()

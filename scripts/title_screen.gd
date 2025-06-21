extends Node2D

@onready var animation_player: AnimationPlayer = $MainMenu/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("button_slide")

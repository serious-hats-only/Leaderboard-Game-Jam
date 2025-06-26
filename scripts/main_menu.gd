extends Control

@onready var button_animation_player: AnimationPlayer = $ButtonAnimationPlayer
@onready var game_start_animation_player: AnimationPlayer = $GameStartAnimationPlayer


func _on_ready() -> void:
	button_animation_player.play("button_slide")

func _on_play_pressed() -> void:
	# zoom into SubViewport code
	game_start_animation_player.play("game_start")
	await game_start_animation_player.animation_finished
	Global.display_speedrun_timer = true
	Global.speedrun_time = 0
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

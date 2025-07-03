extends Control

@onready var button_animation_player: AnimationPlayer = $ButtonAnimationPlayer
@onready var businessman_animation_player: AnimationPlayer = $BusinessmanAnimationPlayer
@onready var eating_sand: AudioStreamPlayer2D = $EatingSand
@onready var impact: AudioStreamPlayer = $Impact
@onready var icg_logo: Sprite2D = $Control/ICGLogo


func _ready() -> void:
	Global.businessman_kicked.connect(into_tv)
	eating_sand.play()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("CTLG"):
		icg_logo.visible = true
	if Input.is_action_just_released("CTLG"):
		icg_logo.visible = false
	if Input.is_action_pressed("story_mode"):
		get_tree().change_scene_to_file("res://scenes/storymode.tscn")
	if Input.is_action_pressed("credits"):
		get_tree().change_scene_to_file("res://scenes/credits.tscn")
			

func into_tv():
	businessman_animation_player.play("character_kicked")
	impact.play()
	await businessman_animation_player.animation_finished
	Global.display_speedrun_timer = true
	Global.speedrun_time = 0
	Global.player_can_move = true
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_ready() -> void:
	button_animation_player.play("instructions")

func _on_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

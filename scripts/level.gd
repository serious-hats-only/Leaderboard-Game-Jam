extends Node2D

var score = 0

@export var complete_run: PackedScene

var run_is_complete = false

@onready var player: Player = $player
@onready var get_player_name: Control = $Control/GetPlayerName
@onready var high_score: AnimatedSprite2D = $Control/NewHighScore
@onready var powerup_base: Area2D = $PowerupBase
@onready var high_score_slam: AudioStreamPlayer = $Control/AudioStreamPlayer
@onready var high_score_animation_player: AnimationPlayer = $Control/HighScoreAnimationPlayer
@onready var fireworks: AudioStreamPlayer = $Control/Fireworks
@export var Firework1Scene: PackedScene
@export var Firework2Scene: PackedScene

#Load these so it doesn't hitch as much?
@onready var spacebackground = $Terrain/Space
@onready var pixelrain = $LeaderboardViewports/PixelRain

var top_10_score = []

func _ready():
	Global.score_submitted.connect(score_submitted_restart)
	powerup_base.global_position = Vector2(randi_range(40, 1047), randi_range(-900, -100))
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("restart") and !run_is_complete:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !run_is_complete and body == player:
		
		Global.player_can_move = false
		Global.display_speedrun_timer = false
		Global.speedrun_time_end = Global.speedrun_time
		player.visible = false
		get_player_name.show()
		
		var complete_run_instantiated = complete_run.instantiate()
		get_node("Control").add_child(complete_run_instantiated)
		run_is_complete = true
		
		var sw_result: Dictionary = await SilentWolf.Scores.get_scores(0).sw_get_scores_complete
		var top_10_score = SilentWolf.Scores.scores[(SilentWolf.Scores.scores).size() - 10]["score"]
		if float(Global.speedrun_time_end) < top_10_score:
			high_score_animation_player.play("high_score_slam")
			await get_tree().create_timer(0.5).timeout
			fireworks.play()
			var fw1 = Firework1Scene.instantiate()
			fw1.global_position = %FireworkMarker2D.global_position
			fw1.scale *= 2 
			add_child(fw1)

			await get_tree().create_timer(0.5).timeout

			var fw2 = Firework2Scene.instantiate()
			fw2.global_position = %FireworkMarker2D_2.global_position
			fw2.scale *= 2 
			add_child(fw2)
			
			var fw3 = Firework2Scene.instantiate()
			fw3.global_position = %FireworkMarker2D_3.global_position
			fw3.scale *= 3
			add_child(fw3)
			
			

func score_submitted_restart():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

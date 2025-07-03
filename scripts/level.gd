extends Node2D

var score = 0

@export var complete_run: PackedScene

var run_is_complete = false

@onready var player: Player = $player
@onready var get_player_name: Control = $Control/GetPlayerName
@onready var powerup_base: Area2D = $PowerupBase


func _ready():
	Global.score_submitted.connect(score_submitted_restart)
	powerup_base.global_position = Vector2(randi_range(40, 1047), randi_range(-1120, 0))
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("restart"):
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

func score_submitted_restart():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

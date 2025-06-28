extends Node2D

var score = 0

@export var complete_run: PackedScene

var run_is_complete = false

@onready var gnome_shower: AudioStreamPlayer2D = $Music/Gnome_Shower
@onready var TLABAE: AudioStreamPlayer2D = $Music/TLABAE
@onready var Beach: AudioStreamPlayer2D = $Music/Beach
@onready var Disco: AudioStreamPlayer2D = $Music/Disco
@onready var player: Player = $player
@onready var get_player_name: Control = $Control/GetPlayerName

func _ready():
	gnome_shower.play()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !run_is_complete and body == player:
		
		Global.player_can_move = false
		Global.display_speedrun_timer = false
		Global.speedrun_time_end = Global.speedrun_time
		get_player_name.show()
		get_player_name.position = player.position
		
		var complete_run_instantiated = complete_run.instantiate()
		get_node("player").add_child(complete_run_instantiated)
		run_is_complete = true

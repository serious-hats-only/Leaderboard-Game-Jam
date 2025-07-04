extends Node

@warning_ignore("unused_signal")
signal score_submitted
@warning_ignore("unused_signal")
signal businessman_kicked
@warning_ignore("unused_signal")
signal time_minus

var player_name: String
var player_list = []

var score = 0

var speedrun_time = 0
var speedrun_time_end = 0
var display_speedrun_timer = false
var player_can_move = false

func _ready():
	SilentWolf.configure({
		"api_key": "joTrMiG9J5DpejRomX2N6CjCGpI6gTf9Tzz8H5c3",
		"game_id": "allstarstest",
 		"log_level": 1
	})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/MainPage.tscn"
	})

func _physics_process(delta: float) -> void:
	leaderboard()

func leaderboard():
	for score in Global.score:
		Global.player_list.append(Global.player_name)

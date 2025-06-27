extends Node

@export var wipe = false
@export var seed = true

func _ready():
	if wipe:
		wipe_scores()
	if seed:
		seed_scores()

func wipe_scores():
	SilentWolf.Scores.wipe_leaderboard()

func seed_scores():
	var name = "ABC"
	for i in range(10):
		var sw_result : Dictionary = await SilentWolf.Scores.save_score(name, i).sw_save_score_complete
		print("Score persisted successfully: " + str(sw_result.score_id))

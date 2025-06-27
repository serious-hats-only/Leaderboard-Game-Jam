extends Node2D

@export var viewport_labels : Array[Label] = []
@export var sprites : Array[GeneratedTextSprite] = []
var player_list_with_pos = []

func _ready() -> void:
	# when scene loads, 
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(0).sw_get_scores_complete
	player_list_with_pos = sort_players_and_add_position(SilentWolf.Scores.scores)
	for i in viewport_labels.size():
		if i >= player_list_with_pos.size():
			break
		var score = player_list_with_pos[i]["score"]
		var name = player_list_with_pos[i]["player_name"]
		var str = str(i) + ". " + name.to_upper() + " " + str(score)
		var strNoPeriod = str.replace('.', '')
		strNoPeriod = strNoPeriod.replace(' ', '')
		viewport_labels[i].text = str
		sprites[i].text = strNoPeriod
		sprites[i].generate()

func sort_by_score_ascending(a, b):
	return a["score"] < b["score"]

func sort_players_and_add_position(player_list):
	player_list.sort_custom(sort_by_score_ascending)
	
	var position = 1
	
	for player in player_list:
		player["position"] = position
		position += 1
	
	return player_list

extends Node2D

@export var viewport_labels : Array[RichTextLabel] = []
@export var sprites : Array[GeneratedTextSprite] = []
var player_list_with_pos = []

var char_colors = {
	'0' = 'red',
	'B' = 'green',
	'A' = 'FFFF00'
}

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
		var strRaw = str

		var spr = sprites[i]
		var n = 0
		var x_pos = spr.position.x
		for c in strRaw:
			n += 1
			#spr.viewport.$Control.$RichTextLabel.text = str(v)
			print(c)
			var vp_text = c
			if char_colors.has(c):
				vp_text = "[color=" + char_colors[c] + "]" + c + "[/color]"
			spr.viewport.get_node("Control").get_node("RichTextLabel").text = vp_text
			spr.text = c
			spr.generate()
			if n == strRaw.length():
				break
			var dupe = spr.duplicate()
			var vp_dupe = spr.viewport.duplicate()
			spr.viewport.get_parent().add_child(vp_dupe)
			dupe.viewport = vp_dupe
			dupe.doOnce = false
			dupe.ready_to_generate = false
			dupe.position = spr.position
			dupe.position.x += 50
			dupe.visible = true
			spr.get_parent().add_child(dupe)
			spr = dupe

func sort_by_score_ascending(a, b):
	return a["score"] < b["score"]

func sort_players_and_add_position(player_list):
	player_list.sort_custom(sort_by_score_ascending)
	
	var position = 1
	
	for player in player_list:
		player["position"] = position
		position += 1
	
	return player_list

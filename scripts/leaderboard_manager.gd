extends Node2D

@export var viewport_labels : Array[RichTextLabel] = []
@export var sprites : Array[GeneratedTextSprite] = []
@export var load_texture : TextureRect = null
@export var load_bg : ColorRect = null
@export var load_text : Label = null
@export var player : Player = null
var player_list_with_pos = []

const SWUtils = preload("res://addons/silent_wolf/utils/SWUtils.gd")

#var bouncy_chars = ['B', '0', 'D', '6', 'P', '8']
#var breaky_chars = ['A', 'X', '9', 'K', 'G', '2', '5']  
#var slippy_chars = ['C', 'I', '1', 'O', 'S']

var char_colors = {
	# Red platforms - bouncy
	'0': 'red',
	'B': 'red',
	'D': 'red',
	'6': 'red',
	'P': 'red',
	'8': 'red',
	
	'bouncy': 'red',
	# Yellow platforms - breaky
	'A': 'FFFF00',
	'X': 'FFFF00',
	'9': 'FFFF00',
	'K': 'FFFF00',
	'G': 'FFFF00',
	'2': 'FFFF00',
	'5': 'FFFF00',
	
	'breaky': 'FFFF00',
	# Light blue platforms - slippy
	'C': 'lightblue',
	'I': 'lightblue',
	'1': 'lightblue',
	'O': 'lightblue',
	'S': 'lightblue',
	'slippy': 'lightblue',
}

var original_bounce_volume
var original_broke_volume
var original_jump_volume
var original_land_volume
var original_blast_volume
var original_charge_volume
var original_coin_volume
var original_doublejump_volume
var original_scared_volume
var original_littlescared_volume
var original_wow_volume
var original_bigwow_volume
var original_slide_volume
var original_wave_volume

var original_bounce_pitch
var original_broke_pitch
var original_jump_pitch
var original_land_pitch
var original_blast_pitch
var original_charge_pitch
var original_coin_pitch
var original_doublejump_pitch
var original_scared_pitch
var original_littlescared_pitch
var original_wow_pitch
var original_bigwow_pitch
var original_slide_pitch
var original_wave_pitch

func _play_all_sfx():
	# Assign values inside the function
	original_bounce_volume = player.bounce.volume_linear
	original_broke_volume = player.broke.volume_linear
	original_jump_volume = player.jump.volume_linear
	original_land_volume = player.land.volume_linear
	original_blast_volume = player.blast.volume_linear
	original_charge_volume = player.charge.volume_linear
	original_coin_volume = player.coin.volume_linear
	original_doublejump_volume = player.doublejump.volume_linear
	original_scared_volume = player.scared.volume_linear
	original_littlescared_volume = player.littlescared.volume_linear
	original_wow_volume = player.wow.volume_linear
	original_bigwow_volume = player.bigwow.volume_linear
	original_slide_volume = player.slide.volume_linear
	original_wave_volume = player.Wave.volume_linear

	original_wave_pitch = player.Wave.pitch_scale
	original_bounce_pitch = player.bounce.pitch_scale
	original_broke_pitch = player.broke.pitch_scale
	original_jump_pitch = player.jump.pitch_scale
	original_land_pitch = player.land.pitch_scale
	original_blast_pitch = player.blast.pitch_scale
	original_charge_pitch = player.charge.pitch_scale
	original_coin_pitch = player.coin.pitch_scale
	original_doublejump_pitch = player.doublejump.pitch_scale
	original_scared_pitch = player.scared.pitch_scale
	original_littlescared_pitch = player.littlescared.pitch_scale
	original_wow_pitch = player.wow.pitch_scale
	original_bigwow_pitch = player.bigwow.pitch_scale
	original_slide_pitch = player.slide.pitch_scale

	player.bounce.volume_linear = 0
	player.broke.volume_linear = 0
	player.jump.volume_linear = 0
	player.land.volume_linear = 0
	player.blast.volume_linear = 0
	player.charge.volume_linear = 0
	player.coin.volume_linear = 0
	player.doublejump.volume_linear = 0
	player.scared.volume_linear = 0
	player.littlescared.volume_linear = 0
	player.wow.volume_linear = 0
	player.bigwow.volume_linear = 0
	player.slide.volume_linear = 0
	player.Wave.volume_linear = 0

	player.Wave.play()
	player.bounce.play()
	player.broke.play()
	player.jump.play()
	player.land.play()
	player.blast.play()
	player.charge.play()
	player.coin.play()
	player.doublejump.play()
	player.scared.play()
	player.littlescared.play()
	player.wow.play()
	player.bigwow.play()
	player.slide.play()
	player.powerup_background("hotdog")
	player.spawn_afterimage()
	
	var time_reduction_instance = player.time_reduction.instantiate()
	var confetti_instance = player.confetti.instantiate()
	var particles = confetti_instance.get_node("GPUParticles2D")
	particles.one_shot = true
	particles.emitting = true
	confetti_instance.global_position = Vector2(0,0)
	get_tree().current_scene.add_child(confetti_instance)
	
	player.charge.finished.connect(_sfx_done)

func _sfx_done():
	load_texture.visible = false
	load_bg.visible = false
	load_text.visible = false
	Global.player_can_move = true
	Global.display_speedrun_timer = true
	
	player.bounce.volume_linear = original_bounce_volume
	player.broke.volume_linear = original_broke_volume
	player.jump.volume_linear = original_jump_volume
	player.land.volume_linear = original_land_volume
	player.blast.volume_linear = original_blast_volume
	player.charge.volume_linear = original_charge_volume
	player.coin.volume_linear = original_coin_volume
	player.doublejump.volume_linear = original_doublejump_volume
	player.scared.volume_linear = original_scared_volume
	player.littlescared.volume_linear  = original_littlescared_volume
	player.wow.volume_linear = original_wow_volume
	player.bigwow.volume_linear = original_bigwow_volume
	player.slide.volume_linear = original_slide_volume

	player.bounce.pitch_scale = original_bounce_pitch
	player.broke.pitch_scale = original_broke_pitch
	player.jump.pitch_scale = original_jump_pitch
	player.land.pitch_scale = original_land_pitch
	player.blast.pitch_scale = original_blast_pitch
	player.charge.pitch_scale = original_charge_pitch
	player.coin.pitch_scale = original_coin_pitch
	player.doublejump.pitch_scale = original_doublejump_pitch
	player.scared.pitch_scale = original_scared_pitch
	player.littlescared.pitch_scale = original_littlescared_pitch
	player.wow.pitch_scale = original_wow_pitch
	player.bigwow.pitch_scale = original_bigwow_pitch
	player.slide.pitch_scale = original_slide_pitch
	player.Wave.volume_linear = original_wave_volume
	player.Wave.pitch_scale = original_wave_pitch
	player.Wave.stop()
	
	player.powerup_background("")

func _ready() -> void:
	# when scene loads, 
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(0).sw_get_scores_complete
	var is_bad = sw_result.has("error_leaderboard_jam")
	if (is_bad):
		print("Going to offline mode...")
		player_list_with_pos = []
		for i in range(10):
			var rand_score = (i+1)*100
			rand_score += randf() * 99.0
			rand_score = snappedf(rand_score, 0.1)
			player_list_with_pos.append({"score": rand_score, "player_name": "ICG"})
	else:
		player_list_with_pos = sort_players_and_add_position(SilentWolf.Scores.scores)
		
	_play_all_sfx()
		
	var speed = 1
	for i in viewport_labels.size():
		#speed *= -1
		if i >= player_list_with_pos.size():
			break
		var score = player_list_with_pos[i]["score"]
		var name = player_list_with_pos[i]["player_name"]
		var str = str(i+1) + ". " + name.to_upper() + " " + str(score)
		var strNoPeriod = str.replace('.', '')
		strNoPeriod = strNoPeriod.replace(' ', '')
		var strRaw = str

		var spr = sprites[i]
		spr.move_speed *= speed
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
			dupe.debug_draw = false
			dupe.viewport = vp_dupe
			dupe.doOnce = false
			dupe.ready_to_generate = false
			dupe.position = spr.position
			#dupe.rotation = randf_range(-0.6, 0.6)
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

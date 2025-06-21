extends Node2D

var score = 0


func _on_submit_pressed() -> void:
	Global.display_speedrun_timer = false
	Global.speedrun_time_end = Global.speedrun_time
	$Control/GetPlayerName.show()
	$Control/Submit.hide()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

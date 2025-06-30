extends Control

@onready var line_edit: LineEdit = $LineEdit



func _on_submit_pressed() -> void:
	if line_edit.text.length() == 3:
		Global.player_name = line_edit.text
		var sw_result : Dictionary = await SilentWolf.Scores.save_score(Global.player_name, Global.speedrun_time_end).sw_save_score_complete
		print("Score persisted successfully: " + str(sw_result.score_id))
		Global.score_submitted.emit()

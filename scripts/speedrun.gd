extends CanvasLayer

var time = Global.speedrun_time

func _physics_process(delta: float) -> void:
	if Global.display_speedrun_timer:
		time = float(time) + delta
		
		update_ui()
	else:
		$Label.text = str(Global.speedrun_time_end)

func update_ui():
	var formatted_time = str(time)
	var decimal_index = formatted_time.find(".")
	
	if decimal_index > 0:
		formatted_time = formatted_time.left(decimal_index + 3) # take only two decimals
	
	Global.speedrun_time = formatted_time
	
	$Label.text = formatted_time

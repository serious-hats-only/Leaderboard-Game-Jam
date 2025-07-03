extends CanvasLayer

var time = Global.speedrun_time
@onready var timer_label: Label = $Label
var original_color = Color.WHITE


func _ready() -> void:
	Global.time_minus.connect(time_reduced_label_update)

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

func time_reduced_label_update():
	var new_color = Color.GREEN
	timer_label.modulate = new_color 
	var tween = create_tween()
	tween.tween_interval(0.4)
	tween.tween_property(timer_label, "modulate", original_color, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	time -= 1.0

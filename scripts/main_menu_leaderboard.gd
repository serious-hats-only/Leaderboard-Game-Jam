extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	float_leaderboard_up()
	
func float_leaderboard_up():
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(0, 45), 1.2).set_trans(Tween.TRANS_QUAD)
	#tween.parallel().tween_property(self, "rotation", rotation + -0.15, 1.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(float_leaderboard_down)

func float_leaderboard_down():
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(0,-45), 1.2).set_trans(Tween.TRANS_QUAD)
	#tween.parallel().tween_property(self, "rotation", rotation + 0.15, 1.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(float_leaderboard_up)

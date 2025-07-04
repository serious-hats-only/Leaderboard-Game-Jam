extends Sprite2D

# line below was throwing errors, commenting out bc it doesn't appear to be needed
#@onready var tween = $Tween

func _ready():
	modulate.a = 0.6  # Start semi-transparent

	var tween := create_tween()
	tween.tween_property(
		self,
		"modulate",
		Color(modulate.r, modulate.g, modulate.b, 0.0),
		0.3
	)
	tween.tween_callback(Callable(self, "queue_free"))

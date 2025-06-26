extends Area2D

var old_gravity = 0

func _ready() -> void:
	self.body_entered.connect(_on_body_enter)
	self.body_exited.connect(_on_body_exit)
	
func _on_body_enter(other):
	print(other.name)
	if other is Player:
		var p = other as Player
		old_gravity = p.gravity
		p.stuck = true
		p.gravity = 0
		p.velocity = Vector2(0,0)
		p.launched = false
		
func _on_body_exit(other):
	print(other.name)
	if other is Player:
		var p = other as Player
		p.gravity = old_gravity
		p.stuck = false

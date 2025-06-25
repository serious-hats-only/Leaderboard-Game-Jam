extends Node2D

@export var confetti: PackedScene

@onready var confetti_pop: AudioStreamPlayer2D = $confetti_pop
@onready var party_horn: AudioStreamPlayer2D = $party_horn
@onready var disco_sample: AudioStreamPlayer2D = $disco_sample
@onready var nice_climb: Control = $Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer


#func _unhandled_input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("confetti_test"):
		#var confetti_instantiated_left:Node2D = confetti.instantiate()
		#var confetti_instantiated_right:Node2D = confetti.instantiate()
		#
		## instantiate left and right confetti streams
		#get_parent().add_child(confetti_instantiated_left)
		#confetti_instantiated_left.global_position = Vector2(0.0, 340.0)
		#confetti_instantiated_left.global_rotation_degrees = 60.0
		#get_parent().add_child(confetti_instantiated_right)
		#confetti_instantiated_right.global_position = Vector2(1152.0, 340.0)
		#confetti_instantiated_right.global_rotation_degrees = -60.0
		#
		## play audio
		#confetti_pop.play()
		#party_horn.play()
		#disco_sample.play()
		#
		## show label
		#nice_climb.visible = true
		#animation_player.play("label_flicker")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var confetti_instantiated_left:Node2D = confetti.instantiate()
	var confetti_instantiated_right:Node2D = confetti.instantiate()
	
	# instantiate left and right confetti streams
	get_parent().add_child.call_deferred(confetti_instantiated_left)
	confetti_instantiated_left.global_position = Vector2(-175.0, 330.0)
	confetti_instantiated_left.global_rotation_degrees = 35.0
	get_parent().add_child.call_deferred(confetti_instantiated_right)
	confetti_instantiated_right.global_position = Vector2(175.0, 330.0)
	confetti_instantiated_right.global_rotation_degrees = -35.0
		
	# play audio
	confetti_pop.play()
	party_horn.play()
	disco_sample.play()
		
	# show label
	nice_climb.visible = true
	animation_player.play("label_flicker")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

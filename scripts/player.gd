class_name Player
extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
#@export var ui: UI

var speed = 100
var acceleration = 500
var friction = 1200

@onready var collision_shape = %CollisionShape2D
@onready var shape = collision_shape.shape


func _ready():
	null
#	Globals.player = self

func _physics_process(delta):
	move(delta)

func move(delta):
	# Visuals
	var horz_move = Input.get_axis("move_left", "move_right")
	if horz_move != 0:
		sprite.play("running")
		sprite.flip_h = horz_move < 0
	else:
		sprite.play("idle")
	
	# Movement
	var move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_dir == Vector2.ZERO:
		apply_friction(friction * delta) #apply friction
	else:
		apply_movement(move_dir * acceleration * delta) #apply movement
	move_and_slide()

func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

func apply_movement(accel):
	velocity += accel
	velocity = velocity.limit_length(speed)

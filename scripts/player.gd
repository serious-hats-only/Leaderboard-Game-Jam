class_name Player
extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
#@export var ui: UI

@export var speed = 100
var acceleration = 500
var friction = 250
var grounded = false
var launched = false

@onready var collision_shape = %CollisionShape2D
@onready var shape = collision_shape.shape

@export var gravity = 20.0
@export var jump_force = 250.0

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
			
	velocity.y += gravity; #apply gravity
	
	move_and_slide()
	var just_launched = false
	var collisions = get_slide_collision_count()
	for i in range(collisions):
		var c = get_slide_collision(i)
		var groups = c.get_collider().get_groups()
		for g in groups:
			if g == 'B': #TODO add more and make this not specific to B
				velocity.y = -2*jump_force
				launched = true
				just_launched = true

	if not is_on_floor() and launched:
		$AnimatedSprite2D.rotate((PI/2.0)*delta)
	else:
		$AnimatedSprite2D.rotation = 0
		if not just_launched: launched = false

	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = -jump_force

func apply_friction(amount):
	if abs(velocity.x) > amount:
		velocity.x -= sign(velocity.x) * amount
	else:
		velocity.x = 0

func apply_movement(accel):
	velocity.x += accel.x
	if abs(velocity.x) > speed: 
		velocity.x = sign(velocity.x) * speed

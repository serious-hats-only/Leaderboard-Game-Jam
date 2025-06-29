class_name Player
extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
#@export var ui: UI

@export var speed = 100
var acceleration = 500
var friction = 250
var grounded = false
var launched = false
var just_launched = false
var stuck = false
var just_broke = false

var kick_velocity = 3600
var isgrounded = true 
@onready var collision_shape = %CollisionShape2D
@onready var shape = collision_shape.shape
@onready var dust = preload("res://scenes/dust.tscn")
@export var gravity = 20.0
@export var jump_force = 250.0

# audio references
@onready var bounce: AudioStreamPlayer2D = $Audio/Bounce
@onready var broke: AudioStreamPlayer2D = $Audio/Broke
@onready var jump: AudioStreamPlayer2D = $Audio/Jump



func _ready():
	null
#	Globals.player = self

func _physics_process(delta):
	move(delta)
	
	if isgrounded == false and is_on_floor() == true: #Instantiate landing dust particles
		var instance = dust.instantiate()
		instance.global_position = $Marker2D.global_position
		get_parent().add_child(instance)
	
	isgrounded = is_on_floor()

func handle_groups(groups):
	for g in groups:
		if g == 'G':
			print("G")
		elif g == 'B' or g == '0': #TODO add more and make this not specific to B
			bounce.play()
			#velocity.y = -2*jump_force
			launched = true
			just_launched = true
		elif g == 'A':
			just_broke = true
			broke.play()

func move(delta):
	if Global.player_can_move:
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
		if stuck:
			velocity.x = 0
		move_and_slide()
		just_launched = false
		
		#we also raycast as fallback when it doesn't detect
		#the collider because of resolution ordering
		#(i'm guessing that's why)
		#var space_state = get_world_2d().direct_space_state
		#var query = PhysicsRayQueryParameters2D.create(position, position + Vector2(0, 70))
		#query.exclude = [self]
		#var result = space_state.intersect_ray(query)
		#if result:
		#	var c = result["collider"]
		#	var groups = c.get_groups()
		#	handle_groups(groups)
		#	if just_launched:
		#		velocity.y = -2*jump_force

		var collisions = get_slide_collision_count()
		for i in range(collisions):
			var c = get_slide_collision(i)
			var groups = c.get_collider().get_groups()
			handle_groups(groups)
			if just_launched:
				var norm = c.get_normal()
				norm *= 1.5*jump_force
				velocity = norm
				continue
			# if launched and hackily check if it's a character
			elif just_broke:# or (launched and groups.size() > 0 and groups[0].length() == 1): 
				c.get_collider().get_parent().queue_free()
				just_broke = false
			#elif groups.size() > 0 and groups[0].length() == 1:
			#	if c.get_collider().get_parent() is GeneratedTextSprite:
			#		var plat = c.get_collider().get_parent() as GeneratedTextSprite
					#velocity.x += plat.move_speed

		if not is_on_floor() and launched:
			$AnimatedSprite2D.rotate((PI/2.0)*delta)
		else:
			$AnimatedSprite2D.rotation = 0
			if not just_launched: launched = false

		if Input.is_action_just_pressed("move_up") and (is_on_floor() or stuck):
			velocity.y = -jump_force
			jump.play()
	
func apply_friction(amount):
	if abs(velocity.x) > amount:
		velocity.x -= sign(velocity.x) * amount
	else:
		velocity.x = 0

func apply_movement(accel):
	velocity.x += accel.x
	if abs(velocity.x) > speed: 
		velocity.x = sign(velocity.x) * speed


func _on_foot_body_entered(body: Node2D) -> void:
	launched = true
	velocity.y = -jump_force
	velocity.x = kick_velocity

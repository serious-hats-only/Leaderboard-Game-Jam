class_name Player
extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
#@export var ui: UI

@export var speed = 100
var acceleration = 500
var is_slippy = false
var default_friction = 250
var ice_friction = 25
var friction = 250
var grounded = false
var launched = false
var just_launched = false
var stuck = false
var just_broke = false
var first_frame_passed = false
var can_jump

var kick_velocity = 3600
var isgrounded = false 
@onready var collision_shape = %CollisionShape2D
@onready var shape = collision_shape.shape
@onready var dust = preload("res://scenes/dust.tscn")
@export var gravity = 20.0
@export var jump_force = 250.0

@export var confetti = preload("res://scenes/confetti.tscn")

# audio references
@onready var bounce: AudioStreamPlayer2D = $Audio/Bounce
@onready var broke: AudioStreamPlayer2D = $Audio/Broke
@onready var jump: AudioStreamPlayer2D = $Audio/Jump
@onready var land: AudioStreamPlayer2D = $Audio/Land



func _ready():
	null
#	Globals.player = self

func _physics_process(delta):
	
	if not first_frame_passed:
		first_frame_passed = true
		isgrounded = is_on_floor()
		return # Skip movement and effects this frame

	move(delta)
	
	var was_grounded = isgrounded
	isgrounded = is_on_floor()

	if first_frame_passed and not was_grounded and isgrounded and float(Global.speedrun_time) > 0.2:
		var instance = dust.instantiate()
		instance.global_position = $Marker2D.global_position
		get_parent().add_child(instance)
		land.play()
		
var bouncy_chars = ['B', '0', 'D', '6', 'P', '8']
var breaky_chars = ['A', 'X', '9', 'K']  
var slippy_chars = ['C', 'I', '1', 'O', 'S']

func handle_groups(groups):
	for g in groups:
		if g == 'G':
			print("G")
		elif bouncy_chars.find(g) >= 0:
			bounce.play()
			#velocity.y = -2*jump_force
			launched = true
			just_launched = true
		elif breaky_chars.find(g) >= 0:
			just_broke = true
			broke.play()
			var confetti_instance = confetti.instantiate()
			# Get the actual GPUParticles2D node
			var particles = confetti_instance.get_node("GPUParticles2D")
			particles.one_shot = true
			particles.emitting = true
			confetti_instance.global_position = $Marker2D.global_position
			get_tree().current_scene.add_child(confetti_instance)
			
			# Remove after particle lifetime
			await get_tree().create_timer(particles.lifetime).timeout
			confetti_instance.queue_free()
		elif slippy_chars.find(g) >= 0:
			is_slippy = true
			
						

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

		is_slippy = false
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
		
		if is_slippy:
			friction = ice_friction
		else:
			friction = default_friction
			
		if not is_on_floor() and launched:
			$AnimatedSprite2D.rotate((PI/2.0)*delta)
		else:
			$AnimatedSprite2D.rotation = 0
			if not just_launched: launched = false
		
		# Handle jump
		if is_on_floor(): can_jump = true
		if Input.is_action_just_pressed("move_up") and (is_on_floor() or stuck) and float(Global.speedrun_time) > 0.2:
			velocity.y = -jump_force
			jump.play()
		elif not is_on_floor() and can_jump:
			if Input.is_action_just_pressed("move_up"):
				velocity.y = -jump_force * 1.5
				can_jump = false

			if is_on_floor(): #Dust when jumping
				var instance = dust.instantiate()
				instance.global_position = $Marker2D.global_position
				get_parent().add_child(instance)
	
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

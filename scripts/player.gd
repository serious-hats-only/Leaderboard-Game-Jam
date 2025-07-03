class_name Player
extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
#@export var ui: UI

#Hotdog powerup
@export var normal_speed = 150.0
var is_hotdog_active = false
var hotdog_timer: Timer

#Deep Dish Powerup 
var is_deepdish_active = false 
var in_cannon_mode = false

#Mustard Powerup
var is_mustard_active = false 

#var level = get_tree().current_scene
#var background = level.get_node("Terrain/Background")

@export var speed = normal_speed
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

#Music
@onready var TLABAE: AudioStreamPlayer2D = $Music/TLABAE
@onready var Beach: AudioStreamPlayer2D = $Music/Beach
@onready var Wave: AudioStreamPlayer2D = $Music/wave
@onready var gnome_shower: AudioStreamPlayer2D = $Music/Gnome_Shower
var music_randomizer = randi_range(1, 2)

@export var confetti = preload("res://scenes/confetti.tscn")
@export var time_reduction: PackedScene

# audio references
@onready var bounce: AudioStreamPlayer2D = $Audio/Bounce
@onready var broke: AudioStreamPlayer2D = $Audio/Broke
@onready var jump: AudioStreamPlayer2D = $Audio/Jump
@onready var land: AudioStreamPlayer2D = $Audio/Land
@onready var blast: AudioStreamPlayer2D = $Audio/Cannon_Blast
@onready var charge: AudioStreamPlayer2D = $Audio/Charge
@onready var coin: AudioStreamPlayer2D = $Audio/Coin

func _ready():
	if music_randomizer == 1:
		gnome_shower.play()
	else:
		TLABAE.play()
	
func powerup_background(rain_type: String = ""):
	var level = get_tree().current_scene
	if level and level.has_node("Terrain/Background") and level.has_node("LeaderboardViewports/PixelRain") and level.has_node("Terrain/Space"):
		var background = level.get_node("Terrain/Background")
		var pixelrain = level.get_node("LeaderboardViewports/PixelRain")
		var spacebackground = level.get_node("Terrain/Space")
		# Toggle Background visibility
		background.visible = not background.visible
		spacebackground.visible = not background.visible
		
		# Show PixelRain opposite to background
		pixelrain.visible = not background.visible
		
		# Toggle specific rain inside PixelRain:
		var hotdog_rain = pixelrain.get_node("HotDogRain")
		var pizza_rain = pixelrain.get_node("PizzaRain")
		
		if rain_type == "hotdog":
			hotdog_rain.visible = true
			hotdog_rain.emitting = true
			pizza_rain.visible = false
			pizza_rain.emitting = false
		elif rain_type == "deepdish":
			hotdog_rain.visible = false
			hotdog_rain.emitting = false
			pizza_rain.visible = true
			pizza_rain.emitting = true
		else:
			# If no rain type or unknown, hide both
			hotdog_rain.visible = false
			hotdog_rain.emitting = false
			pizza_rain.visible = false
			pizza_rain.emitting = false
	else:
		print("Terrain/Background or PixelRain not found or scene not ready")

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

#Power-Up Function
func apply_powerup(type: String, value: float):
	match type:
		"hotdog":
			if not is_hotdog_active:
				start_hotdog_powerup(value)
				print("Unknown powerup type:", type)
		"deepdish":
			if not is_deepdish_active:
				start_deepdish_powerup(value)
				print("Unknown powerup type:", type)
		"mustard":
			if not is_mustard_active:
				null
			

func start_deepdish_powerup(duration: float):
	is_deepdish_active = true
	in_cannon_mode = true
	sprite.play("cannon")
	charge.play()
	
	velocity = Vector2.ZERO

	call_deferred("powerup_background", "deepdish")
	if gnome_shower.playing:
		gnome_shower.stop()
	else:
		TLABAE.stop()
	Wave.play()
	# Wait for animation and launch cannon
	await sprite.animation_finished
	cannon_launch()

func cannon_launch():
	velocity.y = -jump_force * 10  # big upward blast
	blast.play()
	in_cannon_mode = false
	Global.player_can_move = true  # Reenable controls
	$Camera2D.start_shake(10.0)  # Adjust intensity
	
	# Disable collisions while in air
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	Global.player_can_move = true
	Wave.stop()
	if music_randomizer == 1:
		gnome_shower.play()
	else:
		TLABAE.play()

	# Schedule a timer or await floor contact
	await get_tree().create_timer(0.1).timeout  # stay intangible for 0.8 seconds

	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
	Global.player_can_move = true
	call_deferred("powerup_background", "") # hide rain effects and reset background visibility
	
func start_hotdog_powerup(duration: float):
	is_hotdog_active = true
	speed *= 4

	if gnome_shower.playing:
		gnome_shower.stop()
	else:
		TLABAE.stop()
	Beach.play()

	call_deferred("powerup_background", "hotdog")
	
	
	# Add pixel rain effect
	#$PixelRain.visible = true
	#background.visible = false
	
	#pixel_rain_instance = pixel_rain_scene.instantiate()
	#add_child(pixel_rain_instance)
	#pixel_rain_instance.position = Vector2.ZERO  # or adjust as needed
	# Setup and start timer to end the powerup
	hotdog_timer = Timer.new()
	hotdog_timer.wait_time = duration
	hotdog_timer.one_shot = true
	hotdog_timer.timeout.connect(_end_hotdog_powerup)
	add_child(hotdog_timer)
	hotdog_timer.start()

func _end_hotdog_powerup():
	speed = normal_speed
	is_hotdog_active = false

	# Stop hotdog music
	Beach.stop()
	
	if music_randomizer == 1:
		gnome_shower.play()
	else:
		TLABAE.play()
	call_deferred("powerup_background", "") # hide rain effects and reset background visibility
	#background.visible = true
	#$PixelRain.visible = false
	# Remove pixel rain effect
	#if pixel_rain_instance:
	#	pixel_rain_instance.queue_free()
	#	pixel_rain_instance = null

		
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
			coin.play()
			var time_reduction_instance = time_reduction.instantiate()
			get_tree().current_scene.add_child(time_reduction_instance)
			time_reduction_instance.global_position = self.global_position
			var confetti_instance = confetti.instantiate()
			Global.speedrun_time = (float(Global.speedrun_time) - 1.0)
			Global.time_minus.emit()
			print (Global.speedrun_time)
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
	if in_cannon_mode:
		velocity.y += gravity
		velocity.x = 0  # prevent drift
		move_and_slide()
		return
		
	if Global.player_can_move:
		# Visuals
		var horz_move = Input.get_axis("move_left", "move_right")
		# Set animation based on movement state
		if not is_on_floor():
			if velocity.y < 0:
				if sprite.animation != "jump":
					sprite.play("jump")
			elif velocity.y > 0:
				if sprite.animation != "sink":
					sprite.play("sink")
		elif abs(velocity.x) > 5:
			if sprite.animation != "running":
				sprite.play("running")
		else:
			if sprite.animation != "idle":
				sprite.play("idle")

		# Flip sprite based on direction
		if abs(velocity.x) > 5:
			sprite.flip_h = velocity.x < 0
		
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
				$Camera2D.start_shake(4.0)  # Adjust intensity
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
			if sprite.animation != "jump":
				sprite.play("jump")
		elif not is_on_floor() and can_jump:
			if Input.is_action_just_pressed("move_up"):
				velocity.y = -jump_force * 1.5
				jump.play()
				#sprite.play("idle")
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

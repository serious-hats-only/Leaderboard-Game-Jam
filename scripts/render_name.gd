extends Sprite2D
class_name GeneratedTextSprite

@export var debug_draw = false
@export var viewport : SubViewport = null
@export var move_speed = -100

var text = ""
var bodies = []
var char_rigid_body = preload("res://prefabs/char_rigid_body.tscn")
var char_area = preload("res://prefabs/char_area.tscn")
#@export var test_sprite : Sprite2D = null

var bitmap : BitMap = null

func _ready() -> void:
	var text = viewport.get_texture()
	self.texture = text
	
	
var ready_to_generate = false
var doOnce = false
var polys

func _physics_process(delta: float) -> void:
	global_position.x += delta * move_speed
	if global_position.x < -50 and move_speed < 0:
		global_position.x = 1220
	if global_position.x > 1220 and move_speed > 0:
		global_position.x = -50
	#for b in bodies:
#		b.global_position.x += delta * move_speed
#		if b.global_position.x < -50:
#			b.global_position.x = 1220
	#	if debug_draw:
	#		print(b.global_position)
	queue_redraw()


func generate():
	ready_to_generate = true
	RenderingServer.frame_post_draw.connect(convert_string_to_rigidbody)
	
func convert_string_to_rigidbody():
	if doOnce or not ready_to_generate:
		return
	#print("text " + text)
	doOnce = true
	var size = self.texture.get_size()
	var img = self.texture.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(img, 0.0)
	polys = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()), 0)
	for poly in polys:
		var char = '.'
		if bodies.size() < text.length():
			char = text[bodies.size()]
		#print("char " + char)
		var char_rigid = null
		char_rigid = char_rigid_body.instantiate()
		for i in poly.size():
			poly[i] -= size/2.0
		char_rigid.get_child(0).polygon = poly
		char_rigid.add_to_group(char) #add it to a group corresponding to the letter
		add_child(char_rigid)
		bodies.append(char_rigid)
	queue_redraw()
	
func _draw():
	if not doOnce or not debug_draw: return
	for i in range(bodies.size()):
		var body = bodies[i]
		var poly = body.get_child(0).polygon
		var color = Color.BLACK
		draw_colored_polygon(poly, color)

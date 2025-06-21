extends Sprite2D
class_name GeneratedTextSprite

@export var debug_draw = false
@export var viewport : SubViewport = null

var bodies = []
var char_rigid_body = preload("res://prefabs/char_rigid_body.tscn")
#@export var test_sprite : Sprite2D = null

var bitmap : BitMap = null

func _ready() -> void:
	var text = viewport.get_texture()
	self.texture = text
	
	
var ready_to_generate = false
var doOnce = false
var polys

func generate():
	ready_to_generate = true
	RenderingServer.frame_post_draw.connect(convert_string_to_rigidbody)
	
func convert_string_to_rigidbody():
	if doOnce or not ready_to_generate:
		return
	doOnce = true
	var size = self.texture.get_size()
	var img = self.texture.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(img, 0.0)
	polys = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()), 0)
	for poly in polys:
		var char_rigid = char_rigid_body.instantiate()
		for i in poly.size():
			poly[i] -= size/2.0
		#char_rigid.find_child("CollisionPolygon2D")
		char_rigid.get_child(0).polygon = poly
		add_child(char_rigid)
		bodies.append(char_rigid)
	queue_redraw()
	
func _draw():
	if not doOnce or not debug_draw: return
	for body in bodies:
		var poly = body.get_child(0).polygon
		draw_colored_polygon(poly, Color.RED)

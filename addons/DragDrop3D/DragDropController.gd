extends Node

export (float) var ray_length = 100

var draggables = []
var camera: Camera
var draging

func _ready():
	camera = get_tree().get_root().get_camera()
	set_physics_process(false)

func register_draggable(node):
	draggables.append(node)
	node.connect("drag_start",self,"_drag_start")
	node.connect("drag_stop",self,"_drag_stop")
	
func _drag_start(node):
	draging = node
	set_physics_process(true)
	
func _drag_stop(node):
	set_physics_process(false)

func _physics_process(delta):
	var mouse = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse)
	var to = from + camera.project_ray_normal(mouse) * ray_length
	
	var cast = camera.get_world().direct_space_state.intersect_ray(from, 
				to, [draging.get_parent()], draging.get_parent().get_collision_mask(), true, true)
	if not cast.empty():
		draging.on_hover(cast)

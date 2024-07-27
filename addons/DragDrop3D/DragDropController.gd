extends Node3D

@export var ray_length = 100


var draggables = []
var draggables_parents = []
var camera: Camera3D
var dragging: Draggable

func _ready():
    camera = get_viewport().get_camera_3d()
    #set_physics_process(false)

func register_draggable(node: Draggable):
    draggables.append(node)
    node.drag_start.connect(_drag_start)
    node.drag_stop.connect(_drag_stop)
    draggables_parents.append(node.get_parent())

func _drag_start(node: Draggable):
    dragging = node
    #set_physics_process(true)

func _drag_stop(_node: Draggable):
    dragging = null
    #set_physics_process(false)

func _physics_process(_delta):
    if not dragging or not camera :
        return

    var mouse = get_viewport().get_mouse_position()
    var from = camera.project_ray_origin(mouse)
    var to = from + camera.project_ray_normal(mouse) * ray_length

    var space_state = get_tree().get_current_scene().get_world_3d().direct_space_state
    var query = PhysicsRayQueryParameters3D.create(from, to)
    query.exclude = draggables_parents
    query.collision_mask = dragging.get_parent().collision_mask

    var result = space_state.intersect_ray(query)
    if not result.is_empty():
        dragging.on_hover(result)
        

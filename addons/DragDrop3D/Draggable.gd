tool
extends Node

class_name Draggable

signal drag_start(node)
signal drag_stop(node)
signal drag_move(node, cast)

export (int, 0,19) var bit = 19

onready var controller = get_node('/root/DragDropController')
onready var area_layer = get_parent().get_collision_layer()
onready var area_mask = get_parent().get_collision_mask()
var current = null
var drag_offset = Vector2()

var hovered = null

func _get_configuration_warning():
	if not get_parent() is CollisionObject:
		return 'Not under a collision object'
	return ''

func _ready():
	if Engine.editor_hint:
		set_process(false)
		return
	if controller == null:
		printerr('Missing DragDropController singletron!')
	else:
		var draggable = get_parent()
		draggable.connect("mouse_entered",self,"mouse_entered",[draggable])
		draggable.connect("mouse_exited",self,"mouse_exited",[draggable])
		draggable.connect("input_event",self,"input_event",[draggable])
		controller.register_draggable(self)

func mouse_entered(node):
	hovered = node

func mouse_exited(node):
	hovered = null
	
func on_hover(cast):
	emit_signal("drag_move", self, cast)

func input_event(camera, event, click_position, click_normal, shape_idx, node):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			if hovered:
				current = hovered.get_parent()
				emit_signal("drag_start", self)
		elif current:
			emit_signal("drag_stop", self)

func depth_sort(a,b):
	return b.get_index()<a.get_index()


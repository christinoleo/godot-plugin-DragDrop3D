@tool
extends Node
class_name Draggable

signal drag_start(node)
signal drag_stop(node)
signal drag_move(node, cast)

@export var bit: int = 19

var controller
var area_layer: int
var area_mask: int
var current = null
var drag_offset = Vector2()
var hovered = null

func _get_configuration_warning() -> String:
  if not get_parent() is CollisionObject3D:
    return 'Not under a collision object'
  return ''

func _ready():
  if Engine.is_editor_hint():
    set_process(false)
    return
  
  controller = get_node_or_null('/root/DragDropController')
  if controller == null:
    printerr('Missing DragDropController singleton!')
  else:
    var draggable = get_parent()
    if draggable:
      area_layer = draggable.collision_layer
      area_mask = draggable.collision_mask
      draggable.mouse_entered.connect(mouse_entered)
      draggable.mouse_exited.connect(mouse_exited)
      draggable.input_event.connect(input_event)
    controller.register_draggable(self)

func mouse_entered():
  hovered = get_parent()

func mouse_exited():
  hovered = null
  #if current:
    #drag_stop.emit(self)

func on_hover(cast):
  drag_move.emit(self, cast)

func input_event(_camera, event, _click_position, _click_normal, _shape_idx):
  if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
    if event.is_pressed():
      if hovered:
        current = hovered
        drag_start.emit(self)
    elif current:
      drag_stop.emit(self)

func depth_sort(a, b):
  return b.get_index() < a.get_index()

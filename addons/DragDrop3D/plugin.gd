tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Draggable", "Node", load("res://addons/DragDrop3D/Draggable.gd"), load("res://addons/DragDrop3D/draggable_icon.svg"))


func _exit_tree():
	remove_custom_type("DragaDraggableble")


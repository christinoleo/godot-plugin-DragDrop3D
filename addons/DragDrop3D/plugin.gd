@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("DragDropController", "res://addons/DragDrop3D/DragDropController.gd")
	add_custom_type("Draggable", "Node", load("res://addons/DragDrop3D/Draggable.gd"), load("res://addons/DragDrop3D/draggable_icon.svg"))


func _exit_tree():
	remove_autoload_singleton("DragDropController")
	remove_custom_type("DragaDraggableble")


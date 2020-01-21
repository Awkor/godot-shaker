tool
extends EditorPlugin

var type: String = "Shaker"
var base: String = "Node"
var script: Script = preload("res://addons/shaker/source/ShakerNode.gd")
var icon: Texture = preload("res://addons/shaker/assets/shaker_icon.svg")


func _enter_tree() -> void:
	add_custom_type(type, base, script, icon)


func _exit_tree() -> void:
	remove_custom_type(type)
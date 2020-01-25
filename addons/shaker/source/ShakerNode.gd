extends Node
# Most of the logic is based on this talk https://www.youtube.com/watch?v=tu-Qe66AvtY

export(bool) var affect_position = true
export(bool) var affect_rotation = true
export(float) var max_rotation_shake: float = 15 # This value is measured in degrees
export(float) var max_position_shake: float = 1 # This value is measured in meters
export(NodePath) var node_path setget set_node_path
export(float) var trauma_decay = 0.01 # How fast should trauma decay over time
export(bool) var use_time_scale = true # If true, time will affect the shaking

var original_position: Vector3 setget, get_original_position
var original_rotation: Vector3 setget, get_original_rotation
var _elapsed_game_seconds: float = 0
var _noise_generator := OpenSimplexNoise.new()
var _seeds: Array = [randi(), randi(), randi(), randi(), randi(), randi(), randi(), randi(), randi()]
var _trauma_amount: float = 0
var _is_node_rotation_modified: bool = false
var _is_node_position_modified: bool = false

onready var _node: Node = get_node(node_path)


func _process(delta : float) -> void:
	_elapsed_game_seconds += delta
	if _node:
		if _trauma_amount > 0:
			var shake_amount: float = pow(_trauma_amount, 2)
			if affect_rotation:
				if _is_node_rotation_modified == false:
					set_original_rotation(_node)
					_is_node_rotation_modified = true

				if _node is Node2D:
					var rotation_shake: float = _get_shake(max_rotation_shake, shake_amount, _seeds[0])
					_node.rotation = get_original_rotation()
					_node.rotation = deg2rad(rotation_shake)

				if _node is Spatial:
					var x_shake: float = _get_shake(max_rotation_shake, shake_amount, _seeds[1])
					var y_shake: float = _get_shake(max_rotation_shake, shake_amount, _seeds[2])
					var z_shake: float = _get_shake(max_rotation_shake, shake_amount, _seeds[3])
					_node.rotation = get_original_rotation()
					_node.rotate_x(deg2rad(x_shake))
					_node.rotate_y(deg2rad(y_shake))
					_node.rotate_z(deg2rad(z_shake))

			if affect_position:
				if _is_node_position_modified == false:
					set_original_position(_node)
					_is_node_position_modified = true

				if _node is Node2D:
					var x_shake: float = _get_shake(max_position_shake, shake_amount, _seeds[4])
					var y_shake: float = _get_shake(max_position_shake, shake_amount, _seeds[5])
					_node.position = get_original_position()
					_node.translate(Vector2(x_shake, y_shake))

				if _node is Spatial:
					var x_shake: float = _get_shake(max_position_shake, shake_amount, _seeds[6])
					var y_shake: float = _get_shake(max_position_shake, shake_amount, _seeds[7])
					var z_shake: float = _get_shake(max_position_shake, shake_amount, _seeds[8])
					_node.translation = get_original_position()
					_node.translate(Vector3(x_shake, y_shake, z_shake))

		else:
			# Restore the node's position to it's original value if it has been modified
			if _is_node_position_modified:
				if _node is Node2D:
					_node.position = get_original_position()
				if _node is Spatial:
					_node.translation = get_original_position()
				_is_node_position_modified = false
			# Restore the node's rotation to it's original value if it has been modified
			if _is_node_rotation_modified:
				_node.rotation = get_original_rotation()
				_is_node_rotation_modified = false
			# Save the node's position and rotation
			set_original_position(_node)
			set_original_rotation(_node)

	# Decrease trauma linearly
	_trauma_amount = max(_trauma_amount - trauma_decay * Engine.time_scale, 0)

##########
# Trauma #
##########

func add_trauma(amount: float) -> void:
	_trauma_amount = min(_trauma_amount + amount, 1)

#############
# Node path #
#############

func set_node_path(new_value: NodePath) -> void:
	node_path = new_value
	_node = get_node(node_path)
	if _node:
		set_original_position(_node)
		set_original_rotation(_node)

#####################
# Original position #
#####################

func set_original_position(node: Node) -> void:
	if node is Node2D:
		original_position.x = node.position.x
		original_position.y = node.position.y
	if node is Spatial:
		original_position = node.translation


func get_original_position():
	if _node is Node2D:
		return Vector2(original_position.x, original_position.y)
	if _node is Spatial:
		return original_position

#####################
# Original rotation #
#####################

func set_original_rotation(node: Node) -> void:
	if node is Node2D:
		original_rotation.x = node.rotation
	if node is Spatial:
		original_rotation = node.rotation


func get_original_rotation():
	if _node is Node2D:
		return original_rotation.x
	if _node is Spatial:
		return original_rotation

#########
# Noise #
#########

func _get_noise(x: int) -> float:
	var y: float = _elapsed_game_seconds * 1000 if use_time_scale else randi()
	return _noise_generator.get_noise_2d(x, y)

#########
# Shake #
#########

func _get_shake(maximum: float, amount: float, x: int) -> float:
	return maximum * amount * _get_noise(x)
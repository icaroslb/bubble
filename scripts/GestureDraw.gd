extends Gesture

class_name GestureDraw

@export var collision_shape: CollisionShape2D
var node: Node

func _ready() -> void:
	node = get_node("Node")

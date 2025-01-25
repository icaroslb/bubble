extends Node

@export var desenhos: Gesture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func atualizou_nome(nome: StringName, disCloudPoint: float):
	print(nome)

func classificar():
	desenhos.classify()

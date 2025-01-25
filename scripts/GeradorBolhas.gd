extends Node

@export var tempo_geracao: float
@export var cena_bolha: PackedScene

var largura: float = 1102

func _ready() -> void:
	gerar_bolha()


func gerar_bolha():
	var nova_bolha: Bolha = cena_bolha.instantiate()
	
	nova_bolha.mudar_posicao(Vector2(randf_range(50, 1102), 660))
	add_child(nova_bolha)
	
	tempo_geracao = randf_range(0.5, 3.5)
	get_tree().create_timer(tempo_geracao).timeout.connect(gerar_bolha)

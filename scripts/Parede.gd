extends Node

class_name Parede

@export var packed_sujeira: PackedScene
var sujeiras: Array[Sujeira]
const largura_sujeira: float = 45.0
const altura_sujeira: float = 45.0

func _ready() -> void:
	var tela_tamanho: Vector2 = get_viewport().get_visible_rect().size
	
	for l in range(0, tela_tamanho.x, largura_sujeira):
		for a in range(0, tela_tamanho.y, altura_sujeira):
			var nova_sujeira: Sujeira = packed_sujeira.instantiate()
			
			nova_sujeira.adcione_offset(Vector2(l, a))
			sujeiras.append(nova_sujeira)
			add_child(nova_sujeira)

func estourar_bolhas(bolhas: Array) -> float:
	var valor_estourado = 0.0
	
	for bolha: Bolha in bolhas:
		for sujeira in sujeiras:
			valor_estourado += sujeira.remover_sujeira_em_bolha(bolha.global_position, 50 * bolha.scale.x)
	
	return valor_estourado

extends Node

class_name GeradorBolhas

@export var tempo_geracao: float
@export var cena_bolha: PackedScene

var dicionario_bolhas: Dictionary = {"V": null}

var largura: float = 1102

func _ready() -> void:
	get_tree().create_timer(0.5).timeout.connect(gerar_bolha)


func gerar_bolha() -> void:
	var nova_bolha: Bolha = cena_bolha.instantiate()
	
	nova_bolha.mudar_posicao(Vector2(randf_range(50, 1102), 660))
	add_child(nova_bolha)
	
	nova_bolha.estourou.connect(bolha_estorou)
	
	if (dicionario_bolhas.get(nova_bolha.nome_simbolo)):
		dicionario_bolhas[nova_bolha.nome_simbolo].append(nova_bolha)
	else:
		dicionario_bolhas[nova_bolha.nome_simbolo] = [nova_bolha]
	
	tempo_geracao = randf_range(0.5, 3.5)
	get_tree().create_timer(tempo_geracao).timeout.connect(gerar_bolha)

func obter_bolhas(nome_bolhas: StringName) -> Array:
	if (dicionario_bolhas.get(nome_bolhas)):
		return dicionario_bolhas.get(nome_bolhas)
	
	return []

func estourar_bolhas(nome_bolhas: StringName) -> void:
	if (dicionario_bolhas.get(nome_bolhas)):
		var bolhas_estourar: Array = dicionario_bolhas.get(nome_bolhas)
	
		if (bolhas_estourar):
			for bolha in bolhas_estourar:
				bolhas_estourar.erase(bolha)
				bolha.estourar()

func bolha_estorou(bolha: Bolha):
	dicionario_bolhas.get(bolha.nome_simbolo).erase(bolha)
	
	bolha.estourou.disconnect(bolha_estorou)

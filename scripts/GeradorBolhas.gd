extends Node

class_name GeradorBolhas

@export var tempo_geracao: float
@export var cena_bolha: PackedScene
@export var sprites_simbolos: Array[CompressedTexture2D]

var semaforo: Mutex = Mutex.new()

var dicionario_bolhas: Dictionary = {
	"A": [],
	"B": [],
	"C": [],
	"D": [],
	"E": [],
	"F": [],
	"G": [],
	"H": [],
	"I": [],
	"J": [],
	"K": [],
	"L": [],
	"M": [],
	"N": [],
	"O": [],
	"P": [],
	"Q": [],
	"R": [],
	"S": [],
	"T": [],
	"U": [],
	"V": [],
	"W": [],
	"X": [],
	"Y": [],
	"Z": []
	}

const num_A: int = 65

var largura: float = 1102

func _ready() -> void:
	get_tree().create_timer(0.5).timeout.connect(gerar_bolha)


func gerar_bolha() -> void:
	var nova_bolha: Bolha = cena_bolha.instantiate()
	var id_simbolo: String = dicionario_bolhas.keys().pick_random()
	var num_simbolo: int = id_simbolo. to_ascii_buffer()[0]
	var tamanho_bolha: float = randf_range(1.0, 5.0)
	
	nova_bolha.scale = Vector2(tamanho_bolha, tamanho_bolha)
	nova_bolha.mudar_simbolo(sprites_simbolos[num_simbolo - num_A])
	nova_bolha.mudar_posicao(Vector2(randf_range(50, 1102), 660))
	
	dicionario_bolhas[id_simbolo].append(nova_bolha)
	add_child(nova_bolha)
	
	nova_bolha.estourou.connect(bolha_estorou)
	
	tempo_geracao = randf_range(0.5, 2.5)
	get_tree().create_timer(tempo_geracao).timeout.connect(gerar_bolha)

func obter_bolhas(nome_bolhas: StringName) -> Array:
	var copia: Array = []
	
	if (dicionario_bolhas.get(nome_bolhas)):
		for b in dicionario_bolhas.get(nome_bolhas):
			copia.append(b)
	
	return copia

func estourar_bolhas(nome_bolhas: StringName) -> void:
	if (dicionario_bolhas.get(nome_bolhas)):
		var bolhas_estourar: Array = dicionario_bolhas.get(nome_bolhas)
	
		if (bolhas_estourar):
			semaforo.lock()
			for bolha in bolhas_estourar:
				bolhas_estourar.erase(bolha)
				bolha.estourar()
			semaforo.unlock()

func bolha_estorou(bolha: Bolha):
	semaforo.lock()
	dicionario_bolhas.get(bolha.nome_simbolo).erase(bolha)
	semaforo.unlock()
	
	bolha.estourou.disconnect(bolha_estorou)

extends Node

@export var texto_pontucao: Control
@export var fim: Control
@export var gerador_bolhas: GeradorBolhas
@export var parede: Parede
@export var tempo: Tempo

var thread: Thread
var is_playing: bool = true
var pontucao: float

const largura_tela: int = 1152

func _ready() -> void:
	thread = Thread.new()
	fim.visible = false
	centralizar_pontuacao()

func _process(delta: float) -> void:
	pontucao += delta
	texto_pontucao.text = str(floor(pontucao))
	centralizar_pontuacao()

func centralizar_pontuacao() -> void:
	texto_pontucao.position.x = 576 - (texto_pontucao.size.x / 2)

func time_end() -> void:
	is_playing = false
	fim.visible = true

func _input(event: InputEvent) -> void:
	if (is_playing && event is InputEventKey && event.is_pressed()):
		var id_simbolo: String
		
		if (event.keycode >= KEY_A && event.keycode <= KEY_Z):
			id_simbolo = char(event.keycode)
			
			var bolhas: Array = gerador_bolhas.obter_bolhas(id_simbolo)
			if (bolhas):
				var mais_tempo: float = parede.estourar_bolhas(bolhas)
				
				tempo.crescer(mais_tempo)
			
			gerador_bolhas.estourar_bolhas(id_simbolo)

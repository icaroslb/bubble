extends Node2D

class_name Tempo

@export var tempo: Polygon2D
@export var gradiente: GradientTexture1D

signal tempo_zerou

var maximo: float = 1152.0

var valor_maximo: float = 1000
var valor_atual: float = 1000

var velocidade_decaimento: float = 50.0


func _process(delta: float) -> void:
	if (valor_atual > 0.0):
		valor_atual -= velocidade_decaimento * delta
		var valor_calculado: float = conversor()
		
		tempo.polygon[1].x = valor_calculado
		tempo.polygon[2].x = valor_calculado
		
		tempo.color = gradiente.gradient.sample(conversor_porcentagem())
		
		if (valor_atual <= 0):
			tempo_zerou.emit()

func crescer(valor_crescer: float) -> void:
	valor_atual = min(valor_atual + valor_crescer, valor_maximo)

func conversor() -> float:
	return (valor_atual * maximo) / valor_maximo

func conversor_porcentagem() -> float:
	return valor_atual / valor_maximo

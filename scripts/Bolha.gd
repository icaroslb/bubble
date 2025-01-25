extends Node2D

class_name Bolha

@export var sprites_simbolos: Array[CompressedTexture2D]
@export var simbolo: Sprite2D
@export var animacao: AnimatedSprite2D


var x_inicial: float
var amplitude: float
var velocidade: float
var contador: float = 0.0

var nome_simbolo: String

func _ready() -> void:
	var textura_excolhida: CompressedTexture2D = sprites_simbolos.pick_random()
	simbolo.texture = textura_excolhida
	
	amplitude = randf_range(10, 50)
	velocidade  = -randf_range(100, 250)
	
	animacao.play("default")
	#print(animacao.is_playing())

func mudar_posicao(nova_posicao: Vector2) -> void:
	global_position = nova_posicao
	x_inicial = global_position.x


func _process(delta: float) -> void:
	contador += delta
	global_position = Vector2(x_inicial + (sin(contador) * amplitude), global_position.y + (velocidade * delta))
	
	if (global_position.y < -15):
		queue_free()

func explodir():
	pass

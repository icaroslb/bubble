extends Node2D

@export var sprites_simbolos: Array[CompressedTexture2D]
@export var simbolo: Sprite2D
@export var animacao: AnimatedSprite2D


var x_inicial: float
var amplitude: float
var velocidade: float
var contador: float = 0.0

func _ready() -> void:
	simbolo.texture = sprites_simbolos.pick_random()
	amplitude = randf_range(10, 50)
	velocidade  = -randf_range(100, 500)
	
	animacao.play("default")
	#print(animacao.is_playing())

func mudar_posicao(nova_posicao: Vector2) -> void:
	global_position = nova_posicao
	x_inicial = global_position.x


func _process(delta: float) -> void:
	contador += delta
	global_position = Vector2(x_inicial + (sin(contador) * amplitude), global_position.y + (velocidade * delta))

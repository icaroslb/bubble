extends Node2D

class_name Bolha

@export var som: AudioStreamPlayer
@export var simbolo: Sprite2D
@export var animacao: AnimatedSprite2D

signal estourou


var x_inicial: float
var amplitude: float
var velocidade: float
var contador: float = 0.0

var nome_simbolo: String = "V"

var chamar_estorar: bool = false

func _ready() -> void:
	amplitude = randf_range(10, 50)
	velocidade  = -randf_range(100, 250)
	
	animacao.play("default")
	som.finished.connect(destruir)

func mudar_simbolo(textura: CompressedTexture2D) -> void:
	simbolo.texture = textura

func mudar_posicao(nova_posicao: Vector2) -> void:
	global_position = nova_posicao
	x_inicial = global_position.x


func _process(delta: float) -> void:
	if (!chamar_estorar):
		contador += delta
		global_position = Vector2(x_inicial + (sin(contador) * amplitude), global_position.y + (velocidade * delta))
	
		if (global_position.y < (-50 * scale.y)):
			chamar_estorar = true
			estourar()

func estourar():
	estourou.emit(self)
	som.pitch_scale = randf_range(0.8, 1.2)
	som.play()
	self.visible = false

func destruir():
	som.finished.disconnect(destruir)
	call_deferred("queue_free")

extends Node

@export var desenhos: Gesture
@export var gerador_bolhas: GeradorBolhas
@export var parede: Parede

var thread: Thread

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	desenhos.buttonForClassifyUI = "ui_click_right_mouse"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func atualizou_nome(nome: StringName, disCloudPoint: float):
	if (disCloudPoint > 50):
		var bolhas: Array = gerador_bolhas.obter_bolhas(nome)
		
		if (bolhas):
			parede.estourar_bolhas(bolhas)
		
		gerador_bolhas.estourar_bolhas(nome)

func classificar():
	thread = Thread.new()
	
	thread.start(desenhos.classify)
	

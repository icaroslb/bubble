extends Node2D

class_name Sujeira

@export var poligonos: Array[Polygon2D]
@export var qtd_lados_circulo: int

var size_sujeira: Vector2i
var size_gesture: Vector2
var bloco_sujeira: Vector2

func _ready() -> void:
	pass

func adcione_offset(offset: Vector2) -> void:
	var novos_pontos: PackedVector2Array = []
	
	for p in poligonos[0].polygon:
		novos_pontos.append(p + offset)
	
	poligonos[0].polygon = novos_pontos

func generate_circle(centro: Vector2, raio: float) -> PackedVector2Array:
	var pontos_circulo: PackedVector2Array
	var angulo_delta: float = TAU / qtd_lados_circulo
	var angulo: float = 0.0
	
	for i in range(qtd_lados_circulo):
		pontos_circulo.append(Vector2(centro.x + (raio * sin(angulo)), centro.y + (raio * cos(angulo))))
		angulo += angulo_delta
	
	return pontos_circulo

func remover_sujeira_em_bolha(centro: Vector2, raio: float) -> void:
	var bolha: PackedVector2Array = generate_circle(centro, raio)
	
	for poligono in poligonos:
		var intersecao_poligonos: Array[PackedVector2Array] = Geometry2D.intersect_polygons(poligono.polygon, bolha)
		
		if (intersecao_poligonos.size() > 0):
			var novos_pontos_poligonos: Array[PackedVector2Array] = Geometry2D.clip_polygons(poligono.polygon, bolha)
			
			for novos_pontos_poligono in novos_pontos_poligonos:
				var novo_poligono := Polygon2D.new()
				novo_poligono.polygon = novos_pontos_poligono
				poligonos.append(novo_poligono)
				add_child(novo_poligono)
			
			poligonos.erase(poligono)
			poligono.queue_free()

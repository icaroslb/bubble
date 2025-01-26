extends Node2D

class_name Sujeira

@export var poligonos: Array[Polygon2D]
@export var qtd_lados_circulo: int

var pontos_iniciais: PackedVector2Array = [
	Vector2(0, 0),
	Vector2(45, 0),
	Vector2(45, 45),
	Vector2(0, 45),
]

var pontos_reiniciados: PackedVector2Array = [
	Vector2(22.25, 22.25),
	Vector2(22.75, 22.25),
	Vector2(22.75, 22.75),
	Vector2(22.25, 22.75),
]

var cor_inicial: Color

func _ready() -> void:
	cor_inicial = poligonos[0].color
	
	get_tree().create_timer(0.5).timeout.connect(aumentar_sujeira)

func aumentar_sujeira() -> void:
	for p in poligonos:
		var sujeira_crescida: PackedVector2Array = Geometry2D.offset_polygon(p.polygon, randf_range(5, 10))[0]
		var sujerias_geradas := Geometry2D.intersect_polygons(pontos_iniciais, sujeira_crescida)[0]
		
		p.polygon = sujerias_geradas
		
	var next_time: float = randf_range(5.5, 10.5)
	
	get_tree().create_timer(next_time).timeout.connect(aumentar_sujeira)

func adcione_offset(offset: Vector2) -> void:
	for poligono in poligonos:
		poligono.polygon = Transform2D(0, offset) * poligono.polygon
		
	pontos_iniciais = Transform2D(0, offset) * pontos_iniciais
	pontos_reiniciados = Transform2D(0, offset) * pontos_reiniciados

func generate_circle(centro: Vector2, raio: float) -> PackedVector2Array:
	var pontos_circulo: PackedVector2Array
	var angulo_delta: float = TAU / qtd_lados_circulo
	var angulo: float = 0.0
	
	for i in range(qtd_lados_circulo):
		pontos_circulo.append(Vector2(centro.x + (raio * sin(angulo)), centro.y + (raio * cos(angulo))))
		angulo += angulo_delta
	
	return pontos_circulo

func remover_sujeira_em_bolha(centro: Vector2, raio: float) -> float:
	var bolha: PackedVector2Array = generate_circle(centro, raio)
	var area_removida: float = 0.0
	
	for poligono in poligonos:
		var intersecao_poligonos: Array[PackedVector2Array] = Geometry2D.intersect_polygons(poligono.polygon, bolha)
		
		if (intersecao_poligonos.size() > 0):
			for remover in intersecao_poligonos:
				area_removida += calculate_area(remover)
			
			var novos_pontos_poligonos: Array[PackedVector2Array] = Geometry2D.clip_polygons(poligono.polygon, bolha)
			
			for novos_pontos_poligono in novos_pontos_poligonos:
				var novo_poligono := Polygon2D.new()
				
				novo_poligono.polygon = novos_pontos_poligono
				novo_poligono.color = cor_inicial
				poligonos.append(novo_poligono)
				add_child(novo_poligono)
			
			poligonos.erase(poligono)
			poligono.queue_free()
	
	if (poligonos.size() == 0):
		var novo_poligono := Polygon2D.new()
		
		novo_poligono.polygon = pontos_reiniciados
		novo_poligono.color = cor_inicial
		poligonos.append(novo_poligono)
		add_child(novo_poligono)
		
	return area_removida

func calculate_area(pontos: PackedVector2Array) -> float:
	var area: float = 0.0
	var triangularizado: PackedInt32Array = Geometry2D.triangulate_polygon(pontos)
	var qtd_triangulos: int = triangularizado.size() / 3
	
	for indice in range(0, qtd_triangulos):
		var indice_1: int = triangularizado[indice * 3]
		var indice_2: int = triangularizado[(indice * 3) + 1]
		var indice_3: int = triangularizado[(indice * 3) + 2]
		
		var vetor_base: Vector2 = pontos[indice_2] - pontos[indice_1]
		var base: float = vetor_base.length()
		var altura: float = (pontos[indice_3] - (vetor_base * base)).length()
		
		area += (base * altura) / 2.0
	
	return area / 50000
	

extends Area2D

@export var correct_sequence: Array[String] = ["Hieroglyph1", "Hieroglyph3", "Hieroglyph2"]
var current_sequence: Array[String] = []
var slots: Array[Vector2] = []  # Posições dos slots no DropZone
var occupied_slots: Array[bool] = []  # Quais slots estão ocupados
var hieroglyphs_in_zone: Array[Node2D] = []  # Hieroglifos atualmente na zona

func _ready() -> void:
	add_to_group("drop_zone")
	# Definir as posições dos slots baseado na posição do CollisionShape2D
	var shape_node = $CollisionShape2D
	if shape_node and shape_node.shape is RectangleShape2D:
		var rect_size = shape_node.shape.size
		var shape_position = shape_node.global_position
		# Criar 3 slots horizontais
		var slot_width = rect_size.x / 3
		for i in range(3):
			var slot_x = shape_position.x - rect_size.x/2 + slot_width/2 + i * slot_width
			slots.append(Vector2(slot_x, shape_position.y))
			occupied_slots.append(false)

# Chamado quando o hieróglifo é solto sobre a zona
func receive_hieroglyph(hieroglyph: Node2D):
	print("✅ Hieróglifo solto na dropzone:", hieroglyph.name)
	
	# Encontrar um slot vazio
	var slot_index = -1
	for i in range(occupied_slots.size()):
		if not occupied_slots[i]:
			slot_index = i
			break
	
	if slot_index != -1:
		# Posicionar o hieroglifo no slot
		hieroglyph.global_position = slots[slot_index]
		occupied_slots[slot_index] = true
		hieroglyphs_in_zone.append(hieroglyph)
		
		# Adicionar à sequência atual
		current_sequence.append(hieroglyph.name)
		
		# Desativar o arraste temporariamente
		if hieroglyph.has_method("set_dragging_enabled"):
			hieroglyph.set_dragging_enabled(false)
		
		print("Hieroglifo posicionado no slot ", slot_index)
		print("Sequência atual: ", current_sequence)
		
		# Verificar se temos 3 hieroglifos para conferir a sequência
		if current_sequence.size() == 3:
			check_sequence()
	else:
		print("❌ Todos os slots estão ocupados!")

# Função para verificar se um ponto está dentro da área da zona
func overlaps_point(point: Vector2) -> bool:
	var shape_node = $CollisionShape2D
	if shape_node and shape_node.shape is RectangleShape2D:
		var rect_size = shape_node.shape.size
		# Usar a posição do CollisionShape2D, não do Area2D
		var shape_position = shape_node.global_position
		var top_left = shape_position - rect_size * 0.5
		var rect = Rect2(top_left, rect_size)
		return rect.has_point(point)
	return false

func check_sequence() -> void:
	print("🔍 Verificando sequência...")
	print("Sequência atual: ", current_sequence)
	print("Sequência correta: ", correct_sequence)
	
	if current_sequence == correct_sequence:
		print("✅ Sequência correta! Passa de fase!")
		get_tree().create_timer(1.0).timeout.connect(_on_correct_sequence)
		get_tree().change_scene_to_file("res://cenas/transicao_fase2_para_3.tscn")
	else:
		print("❌ Sequência errada! Resetando...")
		get_tree().create_timer(1.0).timeout.connect(_reset_hieroglyphs)

# Função para remover um hieroglifo da zona (se o jogador clicar nele)
func remove_hieroglyph(hieroglyph: Node2D):
	if hieroglyph in hieroglyphs_in_zone:
		var index = hieroglyphs_in_zone.find(hieroglyph)
		if index != -1:
			# Encontrar qual slot estava ocupado
			for i in range(occupied_slots.size()):
				if occupied_slots[i] and slots[i].distance_to(hieroglyph.global_position) < 10:
					occupied_slots[i] = false
					break
			
			# Remover da sequência
			current_sequence.erase(hieroglyph.name)
			hieroglyphs_in_zone.erase(hieroglyph)
			
			# Reativar arraste
			if hieroglyph.has_method("set_dragging_enabled"):
				hieroglyph.set_dragging_enabled(true)
			
			print("🗑️ Hieroglifo removido da zona: ", hieroglyph.name)
			print("Sequência atual: ", current_sequence)

func _on_correct_sequence() -> void:
	# troca de cena ou mostra mensagem
	print("Avançando de fase...")

func _reset_hieroglyphs() -> void:
	current_sequence.clear()
	# Limpar slots ocupados
	for i in range(occupied_slots.size()):
		occupied_slots[i] = false
	
	# Reativar arraste e mover hieroglifos de volta
	for h in hieroglyphs_in_zone:
		if h.has_method("set_dragging_enabled"):
			h.set_dragging_enabled(true)
		if h.has_method("return_to_start"):
			h.return_to_start()
	
	hieroglyphs_in_zone.clear()
	print("🔄 Hieroglifos resetados!")
func _on_DropZone_area_entered(area: Area2D) -> void:
	if area.is_in_group("hieroglyphs"):
		receive_hieroglyph(area)

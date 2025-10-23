extends Area2D

@export var correct_sequence: Array[String] = ["Hieroglyph1", "Hieroglyph2", "Hieroglyph3"]
var current_sequence: Array[String] = []

func _ready() -> void:
	add_to_group("drop_zone")

# Chamado quando o hieróglifo é solto sobre a zona
func receive_hieroglyph(hieroglyph: Node2D):
	print("✅ Hieróglifo solto na dropzone:", hieroglyph.name)
	# Aqui você pode travar o hieróglifo no lugar, tipo:
	hieroglyph.global_position = global_position
	# E desativar o arraste, se quiser:
	if hieroglyph.has_method("set_process_input"):
		hieroglyph.set_process_input(false)

# Função para verificar se um ponto está dentro da área da zona
func overlaps_point(point: Vector2) -> bool:
	var shape_node = $CollisionShape2D
	if shape_node and shape_node.shape is RectangleShape2D:
		var rect_size = shape_node.shape.size
		var top_left = global_position - rect_size * 0.5
		var rect = Rect2(top_left, rect_size)
		return rect.has_point(point)
	return false

func check_sequence() -> void:
	if current_sequence == correct_sequence:
		print("✅ Sequência correta! Passa de fase!")
		get_tree().create_timer(1.0).timeout.connect(_on_correct_sequence)
	else:
		print("❌ Sequência errada! Resetando...")
		get_tree().create_timer(1.0).timeout.connect(_reset_hieroglyphs)

func _on_correct_sequence() -> void:
	# troca de cena ou mostra mensagem
	print("Avançando de fase...")

func _reset_hieroglyphs() -> void:
	current_sequence.clear()
	for h in get_tree().get_nodes_in_group("hieroglyphs"):
		if h.has_method("global_position"):
			h.global_position = h.start_position
func _on_DropZone_area_entered(area: Area2D) -> void:
	if area.is_in_group("hieroglyphs"):
		receive_hieroglyph(area)

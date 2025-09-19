extends TextureButton

func _ready() -> void:
	# Conecta o sinal "pressed" deste botão para chamar a função _on_pressed
	self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	# Troca de volta para a tela inicial
	get_tree().change_scene_to_file("res://cenas/instrucoes.tscn")

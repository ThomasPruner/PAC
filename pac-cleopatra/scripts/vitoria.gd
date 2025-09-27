extends Control

func _ready():
	print("Cena de vitória carregada com sucesso!")
	
	# Configurar botão para voltar ao menu
	$VBoxContainer/VoltarButton.pressed.connect(_on_voltar_button_pressed)
	
	# Adicionar efeito de fade in
	modulate = Color.TRANSPARENT
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 1.0)

func _on_voltar_button_pressed():
	# Efeito de fade out antes de mudar de cena
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	tween.tween_callback(_change_to_menu)

func _change_to_menu():
	get_tree().change_scene_to_file("res://cenas/menu.tscn")

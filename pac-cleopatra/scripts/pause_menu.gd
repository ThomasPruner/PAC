extends Control

func _ready():
	print("Menu de pausa carregado!")
	
	# Configurar botões
	$MenuContainer/ResumeButton.pressed.connect(_on_resume_pressed)
	$MenuContainer/QuitButton.pressed.connect(_on_quit_pressed)
	
	# Efeito de fade in
	modulate = Color.TRANSPARENT
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)

func _on_resume_pressed():
	# Efeito de fade out antes de fechar
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	tween.tween_callback(_resume_game)

func _on_quit_pressed():
	# Efeito de fade out antes de mudar de cena
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	tween.tween_callback(_quit_to_menu)

func _resume_game():
	# Despausar o jogo
	get_tree().paused = false
	# Remover o menu de pausa
	queue_free()

func _quit_to_menu():
	# Despausar antes de mudar de cena
	get_tree().paused = false
	# Ir para o menu
	get_tree().change_scene_to_file("res://cenas/menu.tscn")

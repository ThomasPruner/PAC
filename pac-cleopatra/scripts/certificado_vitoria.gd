extends Control

func _ready():
	# Conectar os botões
	$CertificadoContainer/Borda/Conteudo/BotoesContainer/VoltarMenuButton.pressed.connect(_on_voltar_menu_pressed)
	$CertificadoContainer/Borda/Conteudo/BotoesContainer/JogarNovamenteButton.pressed.connect(_on_jogar_novamente_pressed)
	
	# Efeito de entrada
	modulate = Color.TRANSPARENT
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 1.0)
	
	print("Certificado de vitória exibido!")

func _on_voltar_menu_pressed():
	print("Voltando ao menu principal")
	get_tree().change_scene_to_file("res://cenas/menu.tscn")

func _on_jogar_novamente_pressed():
	print("Reiniciando o jogo")
	# Resetar todas as variáveis globais
	GlobalVars.acertouEscriba = false
	GlobalVars.acertouJoalheiro = false
	GlobalVars.acertouAlimento = false
	GlobalVars.acertouTudo = false
	GlobalVars.player_position = Vector2.ZERO
	
	# Voltar para a primeira fase
	get_tree().change_scene_to_file("res://cenas/main_primeira_fase.tscn")

func _input(event):
	# Permitir fechar com ESC
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		_on_voltar_menu_pressed()

extends Control

func _ready():
	print("=== INICIANDO TRANSIÇÃO FASE 1 → 2 ===")
	
	# Conectar o botão diretamente
	$VBoxContainer/ContinuarButton.pressed.connect(_on_continuar_pressed)
	
	# Conectar o timer
	$Timer.timeout.connect(_on_timer_timeout)
	
	print("Cena de transição carregada - aguardando input do jogador")

func _on_continuar_pressed():
	print("=== BOTÃO CONTINUAR PRESSIONADO ===")
	print("Botão continuar pressionado - indo para fase 2")
	_go_to_phase2()

func _on_timer_timeout():
	print("Timer expirado - indo automaticamente para fase 2")
	_go_to_phase2()

func _go_to_phase2():
	print("=== TENTANDO IR PARA FASE 2 ===")
	get_tree().change_scene_to_file("res://cenas/main_segunda_fase.tscn")

func _input(event):
	# Permitir pular a transição com qualquer tecla
	if event is InputEventKey and event.pressed:
		print("Tecla pressionada - pulando transição")
		_go_to_phase2()

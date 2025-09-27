extends Node

var pause_menu: Control

func _ready():
	# Configurar este nó para funcionar mesmo quando pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Encontrar o menu de pausa na cena
	pause_menu = get_tree().current_scene.get_node("UICanvas/PauseMenu")
	
	# Configurar o menu para funcionar mesmo quando pausado
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Configurar os botões para funcionar mesmo quando pausado
	var resume_button = pause_menu.get_node("MenuContainer/ResumeButton")
	var quit_button = pause_menu.get_node("MenuContainer/QuitButton")
	resume_button.process_mode = Node.PROCESS_MODE_ALWAYS
	quit_button.process_mode = Node.PROCESS_MODE_ALWAYS
	
	print("Pause manager inicializado")

func _input(event):
	# Detectar tecla ESC
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		print("Tecla ESC pressionada!")
		if get_tree().paused:
			# Se já está pausado, despausar
			_resume_game()
		else:
			# Se não está pausado, pausar
			_pause_game()

func _pause_game():
	# Pausar o jogo
	get_tree().paused = true
	
	# Mostrar o menu de pausa
	pause_menu.visible = true
	
	print("Jogo pausado - Menu visível")

func _resume_game():
	print("=== FUNÇÃO _resume_game CHAMADA ===")
	# Despausar o jogo
	get_tree().paused = false
	
	# Esconder o menu de pausa
	pause_menu.visible = false
	
	print("Jogo despausado - Menu escondido")



func _on_resume_button_pressed() -> void:
	print("=== BOTÃO CONTINUAR PRESSIONADO ===")
	_resume_game()

func _on_quit_button_pressed() -> void:
	print("=== BOTÃO VOLTAR AO MENU PRESSIONADO ===")
	_quit_to_menu()

func _quit_to_menu():
	print("botao apertado")
	# Despausar antes de mudar de cena
	get_tree().paused = false
	# Ir para o menu
	get_tree().change_scene_to_file("res://cenas/menu.tscn")

extends Node

var pause_menu: Control

func _ready():
	# Configurar este nó para funcionar mesmo quando pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Aguardar a cena estar pronta antes de tentar acessar os nós
	call_deferred("_setup_pause_menu")
	
	print("Pause manager inicializado")

func _setup_pause_menu():
	# Verificar se get_tree() é válido
	var tree = get_tree()
	if not tree:
		print("Erro: get_tree() retornou null")
		return
	
	# Verificar se a cena atual existe antes de tentar acessá-la
	if not tree.current_scene:
		print("Aviso: current_scene é null, tentando novamente em 0.1s...")
		tree.create_timer(0.1).timeout.connect(_setup_pause_menu)
		return
	
	# Encontrar o menu de pausa na cena
	var current_scene = tree.current_scene
	if not current_scene or not current_scene.has_node("UICanvas/PauseMenu"):
		print("Aviso: UICanvas/PauseMenu não encontrado na cena atual")
		return
		
	pause_menu = current_scene.get_node("UICanvas/PauseMenu")
	
	# Verificar se o pause_menu foi encontrado
	if not pause_menu:
		print("Erro: Não foi possível encontrar o pause_menu")
		return
	
	# Configurar o menu para funcionar mesmo quando pausado
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Configurar os botões para funcionar mesmo quando pausado
	var resume_button = pause_menu.get_node("MenuContainer/ResumeButton")
	var quit_button = pause_menu.get_node("MenuContainer/QuitButton")
	if resume_button:
		resume_button.process_mode = Node.PROCESS_MODE_ALWAYS
	if quit_button:
		quit_button.process_mode = Node.PROCESS_MODE_ALWAYS
	
	print("Pause manager configurado com sucesso")

func _input(event):
	# Detectar tecla ESC
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		print("Tecla ESC pressionada!")
		var tree = get_tree()
		if not tree:
			print("Erro: get_tree() retornou null no _input")
			return
			
		if tree.paused:
			# Se já está pausado, despausar
			_resume_game()
		else:
			# Se não está pausado, pausar
			_pause_game()

func _pause_game():
	# Verificar se o pause_menu está disponível
	if not pause_menu:
		print("Erro: pause_menu não está disponível para pausar o jogo")
		return
	
	# Verificar se get_tree() é válido
	var tree = get_tree()
	if not tree:
		print("Erro: get_tree() retornou null no _pause_game")
		return
	
	# Pausar o jogo
	tree.paused = true
	
	# Mostrar o menu de pausa
	pause_menu.visible = true
	
	print("Jogo pausado - Menu visível")

func _resume_game():
	print("=== FUNÇÃO _resume_game CHAMADA ===")
	
	# Verificar se get_tree() é válido
	var tree = get_tree()
	if not tree:
		print("Erro: get_tree() retornou null no _resume_game")
		return
	
	# Despausar o jogo
	tree.paused = false
	
	# Esconder o menu de pausa se estiver disponível
	if pause_menu:
		pause_menu.visible = false
		print("Jogo despausado - Menu escondido")
	else:
		print("Jogo despausado - pause_menu não disponível")



func _on_resume_button_pressed() -> void:
	print("=== BOTÃO CONTINUAR PRESSIONADO ===")
	_resume_game()

func _on_quit_button_pressed() -> void:
	print("=== BOTÃO VOLTAR AO MENU PRESSIONADO ===")
	_quit_to_menu()

func _quit_to_menu():
	print("botao apertado")
	
	# Verificar se get_tree() é válido
	var tree = get_tree()
	if not tree:
		print("Erro: get_tree() retornou null no _quit_to_menu")
		return
	
	# Despausar antes de mudar de cena
	tree.paused = false
	# Ir para o menu
	tree.change_scene_to_file("res://cenas/menu.tscn")

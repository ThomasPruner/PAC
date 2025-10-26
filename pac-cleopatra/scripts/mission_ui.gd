extends Control

# Referências para os elementos da UI
@onready var escriba_check: Label = $MissionList/EscribaMission/EscribaCheck
@onready var joalheiro_check: Label = $MissionList/JoalheiroMission/JoalheiroCheck
@onready var alimento_check: Label = $MissionList/AlimentoMission/AlimentoCheck

# Timer para atualizar as missões
var update_timer: Timer
var victory_triggered = false

func _ready():
	# Forçar posicionamento fixo na tela
	set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	offset_left = -300
	offset_top = 20
	offset_right = -20
	offset_bottom = 200
	
	# Configurar timer para atualizar missões a cada 0.5 segundos
	update_timer = Timer.new()
	update_timer.wait_time = 0.5
	update_timer.timeout.connect(_update_missions)
	add_child(update_timer)
	update_timer.start()
	
	# Atualizar missões imediatamente
	_update_missions()

func _update_missions():
	# Atualizar status do Escriba
	if GlobalVars.acertouEscriba:
		escriba_check.text = "✅"
		escriba_check.modulate = Color.GREEN
	else:
		escriba_check.text = "❌"
		escriba_check.modulate = Color.WHITE
	
	# Atualizar status do Joalheiro
	if GlobalVars.acertouJoalheiro:
		joalheiro_check.text = "✅"
		joalheiro_check.modulate = Color.GREEN
	else:
		joalheiro_check.text = "❌"
		joalheiro_check.modulate = Color.WHITE
	
	# Atualizar status do Comerciante de Alimentos
	if GlobalVars.acertouAlimento:
		alimento_check.text = "✅"
		alimento_check.modulate = Color.GREEN
	else:
		alimento_check.text = "❌"
		alimento_check.modulate = Color.WHITE
	
	# Verificar se todas as missões foram completadas
	if GlobalVars.acertouEscriba and GlobalVars.acertouJoalheiro and GlobalVars.acertouAlimento and not victory_triggered:
		GlobalVars.acertouTudo = true
		victory_triggered = true
		print("Todas as missões completadas! Mudando para transição...")
		
		# Parar o timer para evitar múltiplas chamadas
		if update_timer:
			update_timer.stop()
		
		# Usar call_deferred para evitar problemas de timing durante a transição
		call_deferred("_load_transition")

func _load_transition():
	print("Carregando transição fase 1 → 2...")
	get_tree().change_scene_to_file("res://cenas/transicao_fase1_para_2.tscn")

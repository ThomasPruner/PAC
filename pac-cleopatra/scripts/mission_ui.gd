extends Control

# Referências para os elementos da UI
@onready var escriba_check: Label = $MissionList/EscribaMission/EscribaCheck
@onready var joalheiro_check: Label = $MissionList/JoalheiroMission/JoalheiroCheck
@onready var alimento_check: Label = $MissionList/AlimentoMission/AlimentoCheck

# Timer para atualizar as missões
var update_timer: Timer

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
	if GlobalVars.acertouEscriba and GlobalVars.acertouJoalheiro and GlobalVars.acertouAlimento:
		GlobalVars.acertouTudo = true
		_show_completion_message()

func _show_completion_message():
	# Criar mensagem de conclusão
	var completion_label = Label.new()
	completion_label.text = "🎉 TODAS AS MISSÕES CONCLUÍDAS! 🎉"
	completion_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	completion_label.add_theme_color_override("font_color", Color.YELLOW)
	completion_label.add_theme_font_size_override("font_size", 16)
	
	# Adicionar ao container de missões
	$MissionList.add_child(completion_label)
	
	# Remover após 5 segundos
	var remove_timer = Timer.new()
	remove_timer.wait_time = 5.0
	remove_timer.one_shot = true
	remove_timer.timeout.connect(func(): completion_label.queue_free())
	add_child(remove_timer)
	remove_timer.start()

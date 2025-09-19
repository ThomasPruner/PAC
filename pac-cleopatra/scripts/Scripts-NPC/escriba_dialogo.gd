extends Control

# Dados do diálogo
var question_data = {
	"question": "Qual é o deus do sol no Egito Antigo?",
	"answers": ["Rá", "Hórus", "Anúbis", "Ísis"]
}

func _ready():
	# Fundo
	var fundo = TextureRect.new()
	fundo.texture = load("res://imagens/templo_egipcio.png")
	fundo.expand = true
	fundo.stretch_mode = TextureRect.STRETCH_SCALE
	fundo.anchor_right = 1.0
	fundo.anchor_bottom = 1.0
	add_child(fundo)

	# Caixa principal
	var margin = MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_top", 50)
	margin.add_theme_constant_override("margin_bottom", 50)
	margin.add_theme_constant_override("margin_left", 200)
	margin.add_theme_constant_override("margin_right", 200)
	add_child(margin)

	var vbox = VBoxContainer.new()
	margin.add_child(vbox)

	# Pergunta
	var label_question = Label.new()
	label_question.text = question_data["question"]
	label_question.autowrap_mode = TextServer.AUTOWRAP_WORD
	label_question.add_theme_font_size_override("font_size", 28)
	vbox.add_child(label_question)

	# Respostas
	var answers_box = VBoxContainer.new()
	answers_box.add_theme_constant_override("separation", 10)
	vbox.add_child(answers_box)

	for i in range(question_data["answers"].size()):
		var button = Button.new()
		button.text = question_data["answers"][i]
		button.pressed.connect(_on_answer_pressed.bind(i))
		answers_box.add_child(button)


func _on_answer_pressed(answer_index: int):
	var resposta = question_data["answers"][answer_index]
	print("Jogador escolheu:", resposta)

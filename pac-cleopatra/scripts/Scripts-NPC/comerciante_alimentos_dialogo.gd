extends Control

func _ready():

	$VBoxContainer/Button.text = "Pão e tâmaras"
	$VBoxContainer/Button2.text = "Lentilhas"
	$VBoxContainer/Button3.text = "Trigo"
	$VBoxContainer/Button4.text = "Um copo de água"

func show_feedback(texto: String, cor: Color) -> void:
	$LabelFeedback.text = texto
	$LabelFeedback.modulate = cor
	$LabelFeedback.visible = true

func _on_button_pressed() -> void:
	show_feedback("Acertou!", Color.GREEN)
	await get_tree().create_timer(2.0).timeout  # espera 2 segundos
	GlobalVars.acertouAlimento = true
	get_tree().change_scene_to_file("res://cenas/main_primeira_fase.tscn")
	

func _on_button_2_pressed() -> void:
	show_feedback("Errou!", Color.RED)

func _on_button_3_pressed() -> void:
	show_feedback("Errou!", Color.RED)

func _on_button_4_pressed() -> void:
	show_feedback("Errou!", Color.RED)

extends Area2D

var player_in_area: bool = false
@onready var interacao_label: Node = $InteracaoLabel
const SCENE_PATH := "res://cenas/instrucoes.tscn"

func _ready() -> void:
	set_process(true)
	$CollisionShape2D.disabled = false
	# Esconde no começo
	if interacao_label:
		interacao_label.visible = false

func _on_area_entered(area: Node) -> void:
	print("area_entered por:", area.name, " | is_in_group('Player'):", area.is_in_group("Player"))
	if area.is_in_group("Player"):
		player_in_area = true
		show_interaction_label()

func _on_area_exited(area: Node) -> void:
	if area.is_in_group("Player"):
		player_in_area = false
		hide_interaction_label()

func _on_body_entered(body: Node) -> void:
	print("body_entered por:", body.name, " | is_in_group('Player'):", body.is_in_group("Player"))
	if body.is_in_group("Player"):
		player_in_area = true
		show_interaction_label()

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_area = false
		hide_interaction_label()

func show_interaction_label():
	# Mostrar label para sarcófago 1 (errado)
	if interacao_label is Label:
		interacao_label.text = "Pressione 'E' para examinar"
		$"../pedra".play()
	
	
	interacao_label.visible = true
	if interacao_label.has_method("show"):
		interacao_label.show()

	# Se o pai estiver escondido, force ele a mostrar
	var p = interacao_label.get_parent()
	if p:
		p.visible = true

func hide_interaction_label():
	if interacao_label:
		interacao_label.visible = false
		if interacao_label.has_method("hide"):
			interacao_label.hide()

func _process(_delta: float) -> void:
	# Sarcófago 1 (errado) - mostrar mensagem
	if player_in_area and Input.is_action_just_pressed("interact"):
		print("❌ Este não é o sarcófago correto!")
		_show_wrong_sarcophagus_message()

func _show_wrong_sarcophagus_message():
	# Mostrar mensagem de que é o sarcófago errado
	var dialog = AcceptDialog.new()
	dialog.title = "Sarcófago Incorreto"
	dialog.dialog_text = "Este sarcófago não contém os tesouros que você procura.\n\nProcure pelo Sarcófago 2 - ele tem uma aparência mais elaborada e ornamentada."
	dialog.size = Vector2(400, 200)
	
	# Adicionar à cena atual
	get_tree().current_scene.add_child(dialog)
	dialog.popup_centered()
	
	# Remover o dialog após ser fechado
	dialog.confirmed.connect(func(): dialog.queue_free())
	dialog.canceled.connect(func(): dialog.queue_free())

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
	# Tenta garantir que o texto exista (Label ou Label2D)
	if GlobalVars.acertouAlimento == false:
		if interacao_label is Label:
			interacao_label.text = "Pressione 'E' para interagir!"

	# Mostra a label de várias formas
	if GlobalVars.acertouAlimento == false:
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
	if GlobalVars.acertouAlimento == false:
		if player_in_area and Input.is_action_just_pressed("interact"):
			var player = get_tree().get_first_node_in_group("Player")
			if player:
				GlobalVars.player_position = player.global_position
			var packed := load(SCENE_PATH) as PackedScene
			if packed:
				get_tree().change_scene_to_file("res://cenas/escribaDialogo.tscn")
			else:
				push_error("Cena não encontrada: " + SCENE_PATH)

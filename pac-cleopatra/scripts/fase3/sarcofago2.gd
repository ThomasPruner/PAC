extends Area2D

var player_in_area: bool = false
@onready var interacao_label: Node = $InteracaoLabel

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
	# Mostrar label de interação para o sarcófago correto
	if interacao_label is Label:
		interacao_label.text = "Pressione 'E' para abrir o sarcófago!"
	
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
	# Permitir interação sempre (sarcófago correto)
	if player_in_area and Input.is_action_just_pressed("interact"):
		print("🎉 Sarcófago correto encontrado! Mostrando certificado de vitória...")
		_show_victory_certificate()

func _show_victory_certificate():
	# Salvar posição do player
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		GlobalVars.player_position = player.global_position
	
	# Mostrar certificado de vitória
	get_tree().change_scene_to_file("res://cenas/certificado_vitoria.tscn")

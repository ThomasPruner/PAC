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

		# Tenta garantir que o texto exista (Label ou Label2D)
		if interacao_label is Label:
			interacao_label.text = "Pressione 'E' para interagir!"

		# Mostra a label de várias formas
		interacao_label.visible = true
		if interacao_label.has_method("show"):
			interacao_label.show()

		# Se o pai estiver escondido, force ele a mostrar
		var p = interacao_label.get_parent()
		if p:
			p.visible = true

func _on_area_exited(area: Node) -> void:
	if area.is_in_group("Player"):
		player_in_area = false
		if interacao_label:
			interacao_label.visible = false
			if interacao_label.has_method("hide"):
				interacao_label.hide()

func _process(_delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("interact"):
		var packed := load(SCENE_PATH) as PackedScene
		if packed:
			get_tree().change_scene_to_file(SCENE_PATH)
		else:
			push_error("Cena não encontrada: " + SCENE_PATH)

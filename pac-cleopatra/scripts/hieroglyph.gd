extends Sprite2D

@onready var start_position: Vector2 = global_position
var dragging := false
var drag_offset := Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and get_rect().has_point(to_local(event.position)):
				dragging = true
				drag_offset = global_position - event.position
				z_index = 10
			elif not event.pressed and dragging:
				dragging = false
				z_index = 0
				check_drop_zone()
	elif event is InputEventMouseMotion and dragging:
		global_position = event.position + drag_offset


func check_drop_zone() -> void:
	for zone in get_tree().get_nodes_in_group("drop_zone"):
		if zone is Area2D:
			# Aqui usamos o método de detecção de ponto dentro da área
			if zone.overlaps_point(global_position):
				zone.receive_hieroglyph(self)
				return
	# se não encontrou nenhuma zona
	global_position = start_position

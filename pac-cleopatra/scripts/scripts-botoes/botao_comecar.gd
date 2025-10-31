extends TextureButton

func _on_pressed() -> void:
	$"../../Som_botão".play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://cenas/tela_transicao.tscn")
	

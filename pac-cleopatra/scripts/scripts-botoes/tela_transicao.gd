extends Control

func _on_continue_button_pressed():
	# Mudar para a cena principal da primeira fase
	get_tree().change_scene_to_file("res://cenas/main_primeira_fase.tscn")

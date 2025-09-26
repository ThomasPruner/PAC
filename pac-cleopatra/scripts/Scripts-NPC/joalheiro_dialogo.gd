extends Control

func _ready():

	$VBoxContainer/Button.text = "Rio Amazonas"
	$VBoxContainer/Button2.text = "Rio Tietê"
	$VBoxContainer/Button3.text = "Rio Pilo"
	$VBoxContainer/Button4.text = "Rio Ísis"

func _on_button_pressed() -> void:
	print("Errou")


func _on_button_2_pressed() -> void:
	print("Errou")


func _on_button_3_pressed() -> void:
	print("Acertou")
	
func _on_button_4_pressed() -> void:
	print("Errou")

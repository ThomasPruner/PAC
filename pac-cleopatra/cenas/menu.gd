extends Control

@onready var musica_inicio = $Musica_inicio
@export var tempo_espera: float = 20.0

func _ready() -> void:
	# Começa a tocar a música
	musica_inicio.play()
	# Conecta o sinal que detecta quando termina
	musica_inicio.connect("finished", Callable(self, "_quando_musica_terminar"))

func _quando_musica_terminar() -> void:
	# Espera o tempo configurado e toca novamente
	await get_tree().create_timer(tempo_espera).timeout
	musica_inicio.play()

extends StaticBody2D

# Script para as barreiras invisíveis do mapa
# Impede que o player saia dos limites do mapa

func _ready():
	# Garantir que as barreiras sejam invisíveis
	$CollisionShape2D.disabled = false
	# Se houver sprite, torná-lo invisível
	if has_node("Sprite2D"):
		$Sprite2D.visible = false
